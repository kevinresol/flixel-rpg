package flixel.rpg.state;

import flixel.FlxState;
import flixel.rpg.display.lighting.Darkness;
import flixel.rpg.display.lighting.Lighting;

/**
 * ...
 * @author Kevin
 */
class GameState extends FlxState
{

	public var hud:HUDSubState;
	
	public var lighting:Lighting;
	
	public function new() 
	{
		super();	
		hud = new HUDSubState();
		setSubState(hud);
	}	
	
	public function enableLighting(color:UInt):Void
	{
		if (lighting != null)
			return;
		
		lighting = new Lighting(this, color);
	}
	
	override public function update():Void 
	{
		if (lighting != null)
			lighting.update();
			
		super.update();
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