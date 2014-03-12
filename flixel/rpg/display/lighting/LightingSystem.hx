package flixel.rpg.display.lighting;
import flixel.FlxState;

/**
 * A system providing lighting effects
 * @author Kevin
 */
class LightingSystem
{
	/**
	 * The darkess that cover the whole screen
	 */
	public var darkness:Darkness;
	
	/**
	 * The state reference that this lighting is hooking at
	 */
	private var state:FlxState;
	
	/**
	 * Array of currently active lights
	 */
	private var dynamicLights:Array<Light>;

	/**
	 * Constructor
	 * @param	state	the state that this Lighting system is hooked to
	 * @param	darknessColor	color of the darkness, with alpha channel. e.g. 0xaa000000
	 */
	public function new(state:FlxState, darknessColor:UInt) 
	{		
		this.state = state;
		
		darkness = new Darkness(darknessColor);
		state.add(darkness);
		
		dynamicLights = [];
	}
	
	/**
	 * Check if any of the dynamic lights are moved
	 * If yes, redraw the whole lighting system at next draw()
	 */
	public function update():Void
	{
		var needToDraw:Bool = false;
		for (l in dynamicLights)
		{
			if (l.moved)
				needToDraw = true;
		}
		
		for (l in dynamicLights)
			l.needToDraw = needToDraw;
		
		darkness.needToDraw = needToDraw;
	}
	
	/**
	 * Add a light to this lighting system
	 */
	public function addDynamicLight(light:Light):Void
	{
		dynamicLights.push(light);		
		light.darkness = darkness;
		
		state.remove(darkness);
		state.add(light);
		state.add(darkness);
		
	}
	
	public function removeDynamicLight(light:Light):Void
	{
		
	}
	
	public function addStaticLight(light:Light):Void
	{
		
	}
	
	public function removeStaticLight(light:Light):Void
	{
		
	}
	
	public function destroy():Void
	{
		//TODO
	}
	
	
}