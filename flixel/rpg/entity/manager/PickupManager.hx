package flixel.rpg.entity.manager;

import flixel.group.FlxTypedGroup;
import flixel.rpg.entity.factory.Factory;
import flixel.rpg.entity.Pickup;

/**
 * ...
 * @author Kevin
 */
class PickupManager extends FlxTypedGroup<Pickup>
{
	private static var manager:PickupManager;

	public function new() 
	{
		super();
	}
	
	public static function create(x:Float, y:Float, id:Int, stack:Int):Pickup
	{
		if (manager == null)
			manager = new PickupManager();
			
		/*var pickup = manager.getFirstAvailable();
		
		if (pickup == null)
		{
			pickup = new Pickup();
			manager.add(pickup);
		}*/
		
		var pickup = manager.recycle(Pickup);
			
		pickup.setPosition(x, y);
		pickup.assignItem(Factory.createInventoryItem(id, stack));
		return pickup;
	}
	
}