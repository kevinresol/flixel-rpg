package flixel.rpg.entity;

import flixel.group.FlxTypedGroup;
import flixel.rpg.ai.FollowAI;
import flixel.rpg.inventory.InventoryItem;
import flixel.rpg.system.HitBox;

/**
 * A pickup is an physical repsentation of an InventoryItem in the game world.
 * Pickup extends Entity with a FollowAI enabled by default. Use one of the 
 * following code to change the behavior of the FollowAI:
	 * pickup.followAI.accelerationMode = AAccelerate(1000, 1000);
	 * pickup.followAI.accelerationMode = AInstant;
 * @author Kevin
 */
class Pickup extends Entity
{
	public static var group(default, null):FlxTypedGroup<Pickup>;
	
	public var item(default, null):InventoryItem;
	public var followAI(default, null):FollowAI;
	
	
	public static function create(x:Float, y:Float, id:Int, stack:Int):Pickup
	{
		if (group == null)
			group = new FlxTypedGroup<Pickup>();
			
		var pickup = group.recycle(Pickup);
			
		pickup.setPosition(x, y);
		pickup.assignItem(InventoryItem.get(id, stack));
		return pickup;
	}
	
	public function new(x:Float = 0, y:Float = 0) 
	{
		super(x, y);		
		
		enableAI();
		followAI = new FollowAI();
		ai.add("follow", followAI);		
	}
	
	override public function update():Void 
	{
		super.update();
		target = null;
	}
	
	override public function kill():Void 
	{
		super.kill();
		item = null;
	}
	
	public function assignItem(item:InventoryItem):Void
	{
		this.item = item;
	}
	
	public static function moveTowardsPlayer(pickupBox:HitBox, pickup:Pickup):Void
	{		
		var inventory = pickupBox.parent.inventory;
		
		//The player does not have slot to hold this item. Don't chase him
		if (inventory.getNonFullItemSlot(pickup.item.id) == null && inventory.getEmptySlot(pickup.item.slotType) == null)
			pickup.target = null;
		else
			pickup.target = pickupBox.parent;	
	}
	
	public static function picked(entity:Entity, pickup:Pickup):Void
	{
		if(entity.inventory.addItem(pickup.item))
			pickup.kill();
	}
	
	
}