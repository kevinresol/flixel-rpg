package flixel.rpg.display.lighting;
import flash.display.BlendMode;
import flash.filters.BlurFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup.FlxTypedGroup;

/**
 * A system providing lighting effects
 * Follow the steps in HammerWatch - http://www.forumopolis.com/showthread.php?p=4296336
 * @author Kevin
 */
class LightingSystem
{
	/**
	 * The darkess that cover the whole screen
	 */
	public var darkness:Darkness;
	
	public var forceRedraw:Bool = false;
	
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
	
	private var ambientAdd:FlxSprite;
	
	private var lightGroup:FlxTypedGroup<Light>;
	

	/**
	 * Constructor
	 * @param	state	the state that this Lighting system is hooked to
	 * @param	darknessColor	color of the darkness, with alpha channel. e.g. 0xaa000000
	 */
	public function new(state:FlxState, darknessColor:UInt, ambientAddColor:UInt) 
	{
		//TODO: only need add and multiply (darkness)
		
		this.state = state;
		
		ambientAdd = new FlxSprite();
		ambientAdd.makeGraphic(FlxG.width, FlxG.height, ambientAddColor);
		ambientAdd.blend = BlendMode.ADD;
		ambientAdd.scrollFactor.set();
		state.add(ambientAdd);
		
		lightGroup = new FlxTypedGroup<Light>();
		state.add(lightGroup);
		
		#if !html5
		darkness = new Darkness(darknessColor, new BlurFilter(15,15)); //TODO parameterize filter
		#end
		
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
		var needToDraw:Bool = false || forceRedraw;
		
		if (!needToDraw)
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
			// dont stamp the light here, allow draw() to do so, 
			// which caters for various things. e.g. screen position. visible, etc
			for (l in dynamicLights)
				l.needToDraw = needToDraw;
				
			for (l in staticLights)
				l.needToDraw = needToDraw;
		
			darkness.resetFill();
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
		
		//state.remove(ambientAdd);		
		//state.remove(darkness);
		
		//state.add(ambientAdd);
		lightGroup.add(light);
		//state.add(darkness);
	}	
	
	private inline function removeLight(from:Array<Light>, light:Light):Void
	{
		from.remove(light);		
		light.darkness = null;
		
		lightGroup.remove(light);
	}
	
	public function destroy():Void
	{
		//TODO
	}
	
	
}