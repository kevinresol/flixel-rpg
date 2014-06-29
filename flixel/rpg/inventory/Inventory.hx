package flixel.rpg.inventory;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxPool;
using flixel.util.FlxArrayUtil;
/**
 * An inventory that holds items. A collection of InventorySlots
 * @author Kevin
 * @see flixel.rpg.inventory.InventoryItem
 * @see flixel.rpg.inventory.InventorySlot
 */
class Inventory implements IFlxDestroyable
{
	private static var pool:FlxPool<Inventory> = new FlxPool<Inventory>(Inventory);
	
	private var slots:Array<InventorySlot>;

	public function new() 
	{		
		slots = []; 		
	}
	
	public static function get():Inventory
	{
		var inventory = pool.get();
		inventory.slots = [];
		return inventory;
	}
	
	/**
	 * Put this back into the recycle pool
	 */
	public function put():Void
	{
		for (s in slots)
			s.put();		
		
		pool.put(this);
	}
	
	/**
	 * Add an item slot to this inventory
	 * @param	slot
	 */
	public inline function addSlot(slot:InventorySlot):Void
	{
		slots.push(slot);
	}
	
	/**
	 * Create some empty slots of the specified type and add to this inventory
	 * @param	type
	 * @param	count
	 */
	public function createEmptySlots(type:Int, count:Int = 1):Void
	{
		for (i in 0...count)
		{
			var slot = InventorySlot.get(type);
			addSlot(slot);
		}
	}
	
	/**
	 * Remove a slot from this inventory
	 * @param	slot
	 * @return	false if this inventory does not contain the specified slot 
	 */
	public inline function removeSlot(slot:InventorySlot):Bool
	{
		return slots.remove(slot);
	}
	
	/**
	 * Remove slots from the inventory. The inventory must has [count] empty slots
	 * of [type] for this method to successfully remove the slots.
	 * @param	type
	 * @param	count
	 * @return	true if successful.
	 */
	public function removeEmptySlots(type:Int, count:Int = 1):Bool
	{
		if (countEmptySlot(type) < count)
			return false;			
		
		for(i in 0...count)
			removeSlot(getEmptySlot(type));
		
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
	
	/**
	 * Remove an item of [amount] from the inventory.
	 * @param	id	id of the item
	 * @param	amount	count (stack) of item to be removed
	 * @return	true if sucessful. false if inventory contains not enough [amount]
	 */
	public function removeItem(id:String, amount:Int):Bool
	{
		if (countItem(id) < amount)
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
	 * Count number of empty slots of the specified type
	 * @param	type
	 * @return
	 */
	public function countEmptySlot(type:Int):Int
	{
		var count:Int = 0;
		for (s in slots)
		{
			if (s.canHold(type) && s.empty)
				count++;
		}
		return count;
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
	public function getNonFullItemSlot(id:String):InventorySlot
	{
		for (s in slots)
		{
			if (!s.empty && s.item.id == id && !s.item.full)
				return s;
		}
		
		return null;
	}
	
	/**
	 * Get the first slot that contains the item [id]
	 * @param	id
	 * @return	null if not found
	 */
	public function getItemSlot(id:String):InventorySlot
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
	public function countItem(id:String):Int
	{
		var total:Int = 0;
		
		for (s in slots)
		{
			if (!s.empty && s.item.id == id)
				total += s.item.stack;
		}
		
		return total;
	}
	
	public inline function has(id:String, stack:Int):Bool
	{
		return countItem(id) >= stack;
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
	
	
	
	
	/**
	 * Clone this inventory and its containing items
	 * @return	a cloned inventory
	 */
	public function clone():Inventory
	{
		var inventory = Inventory.get();
		
		for (s in slots)
			inventory.addSlot(s.clone());
			
		return inventory;
	}
	
	
	/**
	 * Properly destroys the object
	 */
	public function destroy():Void
	{
		slots = null;
	}
	
}