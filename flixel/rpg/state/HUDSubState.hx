package flixel.rpg.state;

import flixel.addons.ui.FlxUISubState;
import flixel.FlxBasic;
import flixel.FlxObject;

/**
 * Any objects added to a HUD will have their scrollFactor set to 0
 * @author Kevin
 */
class HUDSubState extends FlxUISubState
{

	public function new() 
	{
		super();		
	}
	
	public override function create():Void 
	{
		super.create();
		forceScrollFactor(0, 0);
	}
	
	public override function add(Object:FlxBasic):FlxBasic 
	{
		if (Std.is(Object, FlxObject))
			cast(Object, FlxObject).scrollFactor.set();
		
		return super.add(Object);
	}
}