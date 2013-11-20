package flixel.rpg.system;
import flixel.FlxObject;
import flixel.rpg.entity.Entity;

/**
 * ...
 * @author Kevin
 */
class HitBox extends FlxObject
{
	public var parent(default, null):Entity;

	public function new(parent:Entity, width:Int, height:Int)
	{
		super(0, 0, width, height);
		this.parent = parent;
	}
	
	override public function update():Void 
	{
		super.update();
		setPosition(parent.x + (parent.width - width) * 0.5, parent.y + (parent.height - height) * 0.5);
	}
	
}