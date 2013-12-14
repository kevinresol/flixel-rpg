package flixel.rpg.core;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Pickup;
import flixel.rpg.inventory.InventoryItem;

/**
 * ...
 * @author Kevin
 */
class Factory
{
	public function new()
	{
		
	}

	public function createInventoryItem(id:Int, stack:Int):InventoryItem
	{
		var data = RpgEngine.data.getItemData(id);
		
		if (data == null)
			throw "ID not exist";
		
		return InventoryItem.create(id, data.displayName, 0, data.maxStack, stack);
	}
	
	public function createPickup(x:Float, y:Float, id:Int, stack:Int):Pickup
	{
		var pickup = RpgEngine.groups.pickups.recycle(Pickup);
			
		pickup.setPosition(x, y);
		pickup.assignItem(createInventoryItem(id, stack));
		return pickup;
	}
	
	/*public static function createEnemy(id:Int):Enemy
	{
		
	}
	
	public static function createPlayer(id:Int):Enemy
	{
		
	}
	
	
	public static function createPickup(id:Int, stack:Int):Enemy
	{
		
	}*/
	
}