package flixel.rpg.state;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;

/**
 * Any objects added to a HUD will have their scrollFactor set to 0
 * @author Kevin
 */
class HUDSubState extends FlxSubState
{

	public function new() 
	{
		super();		
	}
	
	public override function add(Object:FlxBasic):FlxBasic 
	{
		if (Std.is(Object, FlxObject))
		{
			cast(Object, FlxObject).scrollFactor.set();
		}
		return super.add(Object);
	}
	
	
}