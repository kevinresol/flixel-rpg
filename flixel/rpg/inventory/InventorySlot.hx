package flixel.rpg.inventory;

/**
 * ...
 * @author Kevin
 */
class InventorySlot
{
	/**
	 * Type of this slot. Only matched Item can be put in this slot
	 * Type = 0 is a special case, any items can be put.
	 */
	public var type(default, null):Int;
	
	public var item(default, null):InventoryItem;
	
	public var empty(get, never):Bool;
	private inline function get_empty():Bool { return item == null; }
	
	

	public function new(type:Int) 
	{
		this.type = type;
	}
	
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
	
	public function unhold():InventoryItem
	{
		var i = item;
		item = null;
		return i;
	}
	
	public inline function canHold(type:Int):Bool
	{
		return type == 0 || type == this.type;
	}
	
	public function destroy():Void
	{
		item.destroy();
		item = null;
	}
}