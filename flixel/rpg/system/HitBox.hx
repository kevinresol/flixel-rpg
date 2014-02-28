package flixel.rpg.system;
import flixel.FlxObject;
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
		super(0, 0, width, height);
		this.parent = parent;
	}
	
	/**
	 * Override.
	 * Follow the parent entity
	 */
	override public function update():Void 
	{
		super.update();
		
		setPosition(parent.x + (parent.width - width - parent.offset.x) * 0.5, parent.y + (parent.height - height - parent.offset.y) * 0.5);
	}
	
}