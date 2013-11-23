package flixel.rpg.state;

import flixel.FlxState;

/**
 * ...
 * @author Kevin
 */
class GameState extends FlxState
{

	public var hud:HUDSubState;
	
	public function new() 
	{
		super();	
		hud = new HUDSubState();
		setSubState(hud);
	}	
	
	public var paused(default, set):Bool;
	private function set_paused(v:Bool):Bool
	{
		if (paused != v)
		{
			paused = v;
			persistentUpdate = !v;
		}
		return v;
	}
	
	
}