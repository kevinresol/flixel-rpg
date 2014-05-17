package flixel.rpg.state;

import flixel.FlxState;
import flixel.rpg.display.lighting.LightingSystem;

/**
 * A FlxState with a HUD sub-state and a lighting system
 * @author Kevin
 */
class GameState extends FlxState
{
	/**
	 * The HUD sub-state. All UI should be added here
	 */
	public var hud:HUDSubState;
	
	/**
	 * The Lighting object. Call enableLighting() before accessing this object
	 */
	private var lighting:LightingSystem;
		
		
	override public function create():Void 
	{
		super.create();
		
		persistentUpdate = true;
		persistentDraw = true;
		
		hud = new HUDSubState();
		this.openSubState(hud);
	}
	
	/**
	 * Enable the lighting system
	 * @param	color
	 */
	private function enableLighting(darknessColor:UInt, ambientAddColor:UInt):Void
	{
		if (lighting != null)
			return;
		
		lighting = new LightingSystem(this, darknessColor, ambientAddColor);
	}
	
	
	/**
	 * Override.
	 * Update the lighting system if it is enabled.
	 */
	override public function update():Void 
	{
		if (lighting != null)
			lighting.update();
			
		super.update();
	}
	
	public override function destroy():Void 
	{
		if (lighting != null)
			lighting.destroy();
		
		super.destroy();
	}
	
	/**
	 * Set to true to pause the game. The HUD will still work.
	 */
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