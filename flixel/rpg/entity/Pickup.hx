package flixel.rpg.entity;

import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxVelocity;
import flixel.rpg.entity.factory.Factory;
import flixel.rpg.inventory.InventoryItem;
import flixel.rpg.system.HitBox;

/**
 * ...
 * @author Kevin
 */
class Pickup extends FlxSprite
{
	private var item:InventoryItem;
	
	public var id(get, null):Int;
	private inline function get_id():Int { return item.id; }	
	
	public var slotType(get, null):Int;
	private inline function get_slotType():Int { return item.slotType; }
	
	public var displayName(get, null):String;
	private inline function get_displayName():String { return item.displayName; }
	
	public var stack(get, null):Int;
	private inline function get_stack():Int { return item.stack; }
	
	public var maxStack(get, null):Int;
	private inline function get_maxStack():Int { return item.maxStack;}
	
	public function new(x:Float = 0, y:Float = 0) 
	{
		super(x, y);
		
		makeGraphic(5, 5);
		
		drag.set(600, 600);
		maxVelocity.set(100, 100);
	}
	
	override public function update():Void 
	{
		super.update();
		acceleration.x = acceleration.y = 0;
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
		if (inventory.getNonFullItemSlot(pickup.id) == null && inventory.getEmptySlot(pickup.slotType) == null)
			return;
		
		//Otherwise chase him la!
		var a:Float = FlxAngle.angleBetween(pickup, cast(pickupBox.parent));		
		pickup.acceleration.x = Std.int(Math.cos(a) * 1000);
		pickup.acceleration.y = Std.int(Math.sin(a) * 1000);	
	}
	
	public static function picked(entity:Entity, pickup:Pickup):Void
	{
		if(entity.inventory.addItem(pickup.item))
			pickup.kill();
	}
	
}