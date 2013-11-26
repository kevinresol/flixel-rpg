package flixel.rpg.state;

import flixel.FlxState;
import flixel.rpg.display.fow.FogOfWar;
import flixel.rpg.display.fow.Light;

/**
 * ...
 * @author Kevin
 */
class GameState extends FlxState
{

	public var hud:HUDSubState;
	
	public var fogOfWar:FogOfWar;
	
	public function new() 
	{
		super();	
		hud = new HUDSubState();
		setSubState(hud);
	}	
	
	public function enableFogOfWar(color:UInt):Void
	{
		if (fogOfWar != null)
			return;
		
		fogOfWar = new FogOfWar(this, color);		
		add(fogOfWar);
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