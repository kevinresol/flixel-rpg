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
	 * Array of currently active lights
	 */
	private var staticLights:Array<Light>;

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
		staticLights = [];
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
			{
				needToDraw = true;
				break;
			}
		}
		
		if (!needToDraw)
		for (l in staticLights)
		{
			if (l.moved)
			{
				needToDraw = true;
				break;
			}
		}
		
		if (needToDraw)
		{
			for (l in dynamicLights)
				l.needToDraw = needToDraw;
		
			darkness.needToDraw = needToDraw;
		}
	}
	
	/**
	 * Add a light to this lighting system
	 */
	public function addDynamicLight(light:Light):Void
	{
		addLight(dynamicLights, light);
	}
	
	public function removeDynamicLight(light:Light):Void
	{
		removeLight(dynamicLights, light);
	}
	
	public function addStaticLight(light:Light):Void
	{
		addLight(staticLights, light);
	}
	
	public function removeStaticLight(light:Light):Void
	{
		removeLight(staticLights, light);
	}
	
	private inline function addLight(to:Array<Light>, light:Light):Void
	{
		to.push(light);		
		light.darkness = darkness;
		
		state.remove(darkness);
		state.add(light);
		state.add(darkness);
	}	
	
	private inline function removeLight(from:Array<Light>, light:Light):Void
	{
		from.remove(light);		
		light.darkness = null;
		
		state.remove(light);
	}
	
	public function destroy():Void
	{
		//TODO
	}
	
	
}