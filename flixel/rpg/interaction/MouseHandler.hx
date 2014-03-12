package flixel.rpg.interaction;
import flixel.FlxSprite;
import flixel.plugin.MouseEventManager;
import flixel.rpg.entity.Entity;

/**
 * Provide mouse interactions to an Entity using MouseEventManager
 * @author Kevin
 */
class MouseHandler
{
	public var downHandler:Entity->Void;
	public var upHandler:Entity->Void;
	public var overHandler:Entity->Void;
	public var outHandler:Entity->Void;
	
	public var isPressed(default, null):Bool;
	public var isOver(default, null):Bool;

	public function new(entity:Entity, pixelPerfect:Bool = false):Void
	{
		MouseEventManager.add(entity, onMouseDown, onMouseUp, onMouseOver, onMouseOut , false, true, pixelPerfect);
	}
	
	private function onMouseDown(s:FlxSprite)
	{
		if (downHandler != null) downHandler(cast s);
		isPressed = true;	
	}
	
	private function onMouseUp(s:FlxSprite)
	{
		if (upHandler != null) upHandler(cast s);
		isPressed = false;	
	}
	
	private function onMouseOver(s:FlxSprite)
	{
		if (overHandler != null) overHandler(cast s);
		isOver = true;
	}
	
	private function onMouseOut(s:FlxSprite)
	{
		if (outHandler != null) outHandler(cast s);
		isOver = false;	
	}
	
	
	
}