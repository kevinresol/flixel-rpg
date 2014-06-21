package flixel.rpg.system;
import flixel.FlxObject;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;

/**
 * A hitbox meant to be added to an entity for various purpose.
 * Because we sometimes need several hitboxes (of different sizes).
 * e.g. As a pick-up range.
 * @author Kevin
 */
class HitBox extends FlxObject
{
	/**
	 * The parent entity
	 */
	public var parent(default, null):Entity;

	/**
	 * Constructor
	 * @param	parent
	 * @param	width
	 * @param	height
	 */
	public function new(parent:Entity, width:Int, height:Int)
	{
		this.parent = parent;
		super(parent.x, parent.y, width, height);
		moves = false; // avoid the updateMotion() call, the position of hitboxes are controlled by the parent (see parents x/y setters)
		setPosition(parent.x, parent.y); // set position again to reflect the width/height (in FlxObject constructor w/h is set after x/y)
	}
	
	override function set_x(NewX:Float):Float 
	{
		return super.set_x(NewX + (parent.width - width - parent.offset.x) * 0.5);
	}
	
	override function set_y(NewY:Float):Float 
	{
		return super.set_y(NewY + (parent.height - height - parent.offset.y) * 0.5);
	}
}