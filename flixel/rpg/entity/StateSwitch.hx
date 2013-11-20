package flixel.rpg.entity;
import flixel.addons.display.FlxExtendedSprite;
using Lambda;
/**
 * ...
 * @author Kevin
 */
class StateSwitch extends FlxExtendedSprite
{

	public static inline var SWITCH_MODE_INSTANT:Int = 0;
	public static inline var SWITCH_MODE_ANIMATION_END:Int = 1;	
	
	public static inline var CONNECT_MODE_TOGGLE:Int = 0;
	public static inline var CONNECT_MODE_SYNC:Int = 1;
	
	public var switchMode:Int = SWITCH_MODE_ANIMATION_END;
	
	public var state(default, null):Int; 
	public var numStates:Int;
	
	/**
	 * List of callbacks to be called when the state is changed
	 */
	private var callbacks:Map <Int, StateSwitch->Void> ;
	
	/**
	 * A StateSwitchGroup can contain serveral StateSwitches
	 * And a StateSwitch can be conatined by serveral StateSwitchGroups
	 * This array stores the groups containing [this]
	 */
	public var groups:Array<StateSwitchGroup>;
	
	
	/**
	 * An array of connected toggles.
	 */
	private var connected:Array<StateSwitch>;
	
	private var connectModes:Map<StateSwitch, Int>;
	
	/**
	 * Constructor
	 * @param	x
	 * @param	y
	 */
	public function new(x:Float=0, y:Float=0, numStates:Int) 
	{
		super(x, y);
		this.numStates = numStates;
		
		animation.callback = animationCallback;		
		connectModes = new Map<StateSwitch, Int>();
		callbacks = new Map < Int, StateSwitch->Void > ();
		connected = [];
		groups = [];
	}
	
	
	/**
	 * Switch state by a delta. E.g. current state is 2, jumpState(3) means 
	 * switchState(2+3). Auto loop if the state+delta is out of range.
	 * @param	delta
	 */
	public function jumpState(delta:Int):Void
	{
		var toState = state + delta;
		
		if (toState < 0)
			toState += numStates;
			
		if (toState >= numStates)
			toState -= numStates;
			
		switchState(toState);
	}
	
	/**
	 * Switch the state. State changes and the corresponding callback is called
	 * immediately if switchMode is SWITCH_MODE_INSTANT. Otherwise the actual 
	 * switching will happen at the end of the animation.
	 */
	public function switchState(state:Int):Void
	{
		if (this.state == state)
			return;
		
		//play animation
		var animationName = getAnimationName(this.state, state);		
		if (animation.get(animationName) == null)
		{
			//SWITCH_MODE_ANIMATION_END requires an animation
			if (switchMode == SWITCH_MODE_ANIMATION_END)
				throw "Animation named '" + animationName + "' must be set if toggleMode == TOGGLE_MODE_ANIMATION_END";
		}
		else
			animation.play(animationName);
			
		//Switch the state immediately
		if (switchMode == SWITCH_MODE_INSTANT)
			internalSwitchState(state);		
	}	
	
	/**
	 * @private
	 * Actually switch the state.
	 */
	private inline function internalSwitchState(state:Int):Void
	{
		//Change the state
		this.state = state;
		
		//Callbacks
		var cb = callbacks.get(state);		
		if (cb != null)
			cb(this);
		
		//Tell groups that my state is changed
		notifyGroups();
	}
	
	/**
	 * Animation callback. Switch the state at the end of the anmiation if
	 * switchMode == SWITCH_MODE_ANIMATION_END.
	 * @param	animationName
	 * @param	currentFrame
	 * @param	currentFrameIndex
	 */
	private function animationCallback(animationName:String, currentFrame:Int, currentFrameIndex:Int):Void
	{		
		if (animation.get(animationName).finished)
		{			
			if (switchMode == SWITCH_MODE_ANIMATION_END)
			{
				var toState = Std.parseInt(animationName.split("->")[1]);
				internalSwitchState(toState);	
			}				
			
		}		
	}	
	
	/**
	 * Connect another stateSwitch to this stateSwitch.
	 * @param	stateSwitch
	 * @param	connectMode
	 */
	public function connect(stateSwitch:StateSwitch, connectMode:Int):Void
	{		
		var index = connected.indexOf(stateSwitch);
		
		if (index == -1)
		{
			connected.push(stateSwitch);
			connectModes.set(stateSwitch, connectMode);
		}
	}
	
	/**
	 * Disconnect a connected stateSwitch.
	 * @param	stateSwitch
	 */
	public function disconnect(stateSwitch:StateSwitch):Void
	{
		if (connected.remove(stateSwitch))
			connectModes.remove(stateSwitch);
		
	}
	
	/**
	 * A callback to be called when the state is actually changed to [state]
	 * @param	state
	 * @param	callback
	 */
	public inline function setCallback(state:Int, callback:StateSwitch->Void):Void
	{
		callbacks.set(state, callback);
	}
	
	public inline function getAnimationName(fromState:Int, toState:Int):String
	{
		return fromState + "->" + toState;
	}
	
	/**
	 * Notify the groups containing [this]. Called when state actually changed.
	 */
	public function notifyGroups():Void
	{
		for (g in groups)
			g.checkSwitches();
	}
}