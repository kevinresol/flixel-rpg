package flixel.rpg.inventory;

/**
 * ...
 * @author Kevin
 */
class Inventory
{
	public var slots:Array<InventorySlot>;

	public function new() 
	{		
		slots = [];
	}
	
	/**
	 * Add some item slots to this inventory
	 * @param	type
	 * @param	count
	 */
	public function addSlot(type:Int, count:Int = 1):Void
	{
		for (i in 0...count)
			slots.push(new InventorySlot(type));
	}
	
	/**
	 * Remove slots from the inventory. The inventory must has [count] empty slots
	 * of [type] for this method to successfully remove the slots.
	 * @param	type
	 * @param	count
	 * @return	true if successful.
	 */
	public function removeSlot(type:Int, count:Int = 1):Bool
	{
		var slotsToRemove:Array<InventorySlot> = [];
		
		for (i in 0...count)
		{
			var s = getEmptySlot(type);
			
			if (s == null)
				return false;
			else
				slotsToRemove.push(s);
		}
		
		for(s in slotsToRemove)
			slots.remove(s);
		
		return true;
	}
	
	/**
	 * Add an item to the inventory. Will try to add as many stack as possible
	 * to the inventory. Any remaining stack is returned. Return null if all
	 * stack is added to the inventory successufully.
	 * @param	item
	 * @return	if the item is not fully added to the inventory, the remaining stacks
	 * 			will remain in the item and the function returns false. Otherwise returns
	 * 			true.
	 */
	public function addItem(item:InventoryItem):Bool
	{
		var index:Int;
		var slot:InventorySlot;
		
		//Recursively add the item to existing non-full stacks (until all existing stacks are full)
		while (item.stack > 0 && (slot = getNonFullItemSlot(item.id)) != null)
		{
			slot.item.addToStack(item);
		}
		//If there remaining stack after the prevouis step, find an empty slot and put it there
		if (item.stack > 0)
		{
			slot = getEmptySlot(item.slotType);
			if (slot == null) //no more empty slot
				return false;
			else //there is an empty slot
			{
				slot.hold(item); 
				return true;
			}
		}
		else
			return true;
	}
	
	public function removeItem(id:Int, amount:Int):Bool
	{
		if (countStack(id) < amount)
			return false;
		
		var slot:InventorySlot;		
		trace("init amount", amount);
		while (amount > 0 && (slot = getItemSlot(id)) != null)
		{			
			var i = slot.item.removeFromStack(amount);
			amount -= i.stack;
			
			if (slot.item.stack == 0)
				slot.unhold();
		}
		
		
		
		return true;
	}
	
	
	/**
	 * Get an empty slot of the type.
	 * @param	type
	 * @return	An InventorySlot instance. null if no empty slots
	 */
	public function getEmptySlot(type:Int):InventorySlot
	{
		for (s in slots)
		{
			if (s.canHold(type) && s.empty)
				return s;
		}
		
		return null;
	}
	
	/**
	 * Get a slot holding that item id and such item stack is not full
	 * @param	id
	 * @return 	An InventorySlot instance. null if not found
	 */
	public function getNonFullItemSlot(id:Int):InventorySlot
	{
		for (s in slots)
		{
			if (!s.empty && s.item.id == id && !s.item.full)
				return s;
		}
		
		return null;
	}
	
	public function getItemSlot(id:Int):InventorySlot
	{
		for (s in slots)
		{
			if (!s.empty && s.item.id == id)
				return s;
		}
		return null;
	}
	
	
	/**
	 * Get the total stack (across all slots) of the item [id]
	 * @param	id
	 * @return	total stack
	 */
	public function countStack(id:Int):Int
	{
		var total:Int = 0;
		
		for (s in slots)
		{
			if (!s.empty && s.item.id == id)
				total += s.item.stack;
		}
		
		return total;
	}
	
	/**
	 * Debug string
	 */
	private function toString():String
	{
		var result:Array<String> = [];
		
		for (s in slots)
		{
			if (s.empty)
				result.push(null);
			else
				result.push(s.item.toString());
		}
		
		return result.join(",");
	}
	
	public function destroy():Void
	{
		for (s in slots)
			s.destroy();
		
		slots = null;
	}
	
}