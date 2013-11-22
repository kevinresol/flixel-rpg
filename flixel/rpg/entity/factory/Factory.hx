package flixel.rpg.entity.factory;
import flixel.rpg.data.Data;
import flixel.rpg.inventory.InventoryItem;

/**
 * ...
 * @author Kevin
 */
class Factory
{

	public static function createInventoryItem(id:Int, stack:Int):InventoryItem
	{
		var data = Data.getItemData(id);
		
		if (data == null)
			throw "ID not exist";
		
		return new InventoryItem(id, data.displayName, 0, data.maxStack, stack);
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