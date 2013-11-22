package flixel.rpg.inventory;

/**
 * An inventory slot that can hold one InventoryItem.
 * @author Kevin
 * @see flixel.rpg.inventory.InventoryItem
 * @see flixel.rpg.inventory.Inventory
 */
class InventorySlot
{
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
	private inline function get_empty():Bool { return item == null; }
	
	
	/**
	 * Constructor
	 * @param	type
	 */
	public function new(type:Int) 
	{
		this.type = type;
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
	 * Properly destroys the object
	 */
	public function destroy():Void
	{
		item.destroy();
		item = null;
	}
}