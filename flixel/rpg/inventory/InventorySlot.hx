package flixel.rpg.inventory;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxPool;

/**
 * An inventory slot that can hold one InventoryItem.
 * @author Kevin
 * @see flixel.rpg.inventory.InventoryItem
 * @see flixel.rpg.inventory.Inventory
 */
class InventorySlot implements IFlxDestroyable
{
	
	private static var pool:FlxPool<InventorySlot> = new FlxPool<InventorySlot>(InventorySlot);
	/**
	 * Type of this slot. Only matched Item can be put in this slot
	 * Type = 0 is a special case, any items can be put.
	 */
	public var type(default, null):Int;
	
	/**
	 * The held item
	 */
	public var item(default, null):InventoryItem;
	
	/**
	 * If the slot is empty
	 */
	public var empty(get, never):Bool;
	
	
	/**
	 * Do not use this contructor to create an instance.
	 * Use InventorySlot.get instead.
	 */
	private function new() 
	{
		
	}
	
	/**
	 * Create a slot or recycle one from the pool
	 * @param	type
	 * @return
	 */
	public static function get(type:Int):InventorySlot
	{
		var slot = pool.get();
		slot.type = type;
		return slot;
	}
	
	/**
	 * Put this back into the recycle pool
	 */
	public function put():Void
	{
		if(item != null)
			item.put();
		
		pool.put(this);
	}
	
	/**
	 * Hold the item
	 * @param	item
	 * @return	false if already held an item
	 */
	public function hold(item:InventoryItem):Bool
	{
		//Add the item if this slot is empty
		if (this.item == null)
		{
			this.item = item;
			return true;
		}
		else //This slot is not empty, cannot add
			return false;
	}
	
	/**
	 * Cease holding the item
	 * @return	the held item. null if currently holding nothing
	 */
	public function unhold():InventoryItem
	{
		var i = item;
		item = null;
		return i;
	}
	
	/**
	 * Check if this slot can hold the specified type of item.
	 * Can always holds an item with slotType == 0
	 * @param	type
	 * @return	true if can hold
	 */
	public inline function canHold(type:Int):Bool
	{
		return type == 0 || type == this.type;
	}
	
	/**
	 * Clone this slot
	 * @return
	 */
	public function clone():InventorySlot
	{
		var slot = InventorySlot.get(type);
		
		if (item != null)
			slot.hold(item.clone());
			
		return slot;
	}
	
	/**
	 * Properly destroys the object
	 */
	public function destroy():Void
	{
		item = null;
	}
	
	private inline function get_empty():Bool return item == null;
}