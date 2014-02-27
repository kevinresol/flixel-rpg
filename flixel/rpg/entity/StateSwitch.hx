package flixel.rpg.entity;
import flixel.addons.display.FlxExtendedSprite;
using Lambda;
/**
 * ...
 * @author Kevin
 */
class StateSwitch<T:EnumValue>
{
	public var entity:Entity;
	
	public var switchMode:SwitchMode;
	
	public var state(default, null):T;
	
	/**
	 * Runtime value of T
	 */
	private var stateType:Enum<Dynamic>;
	
	/**
	 * List of callbacks to be called when the state is changed
	 */
	private var callbacks:Map <T, StateSwitch<T>->Void> ;
	
	/**
	 * A StateSwitchGroup can contain serveral StateSwitches
	 * And a StateSwitch can be conatined by serveral StateSwitchGroups
	 * This array stores the groups containing [this]
	 */
	public var groups:Array<StateSwitchGroup<T>>;
	
	
	/**
	 * An array of connected toggles.
	 */
	private var connected:Array<StateSwitch<T>>;
	
	private var connectModes:Map<StateSwitch<T>, ConnectMode>;
	
	/**
	 * Constructor
	 * @param	x
	 * @param	y
	 */
	public function new(entity:Entity, initialState:T) 
	{
		this.entity = entity;
		switchMode = SInstant;
		state = initialState;
		stateType = Type.getEnum(state);
		entity.animation.callback = animationCallback;		
		connectModes = new Map<StateSwitch<T>, ConnectMode>();
		callbacks = new Map < T, StateSwitch<T>->Void > ();
		connected = [];
		groups = [];
	}
	
	
	/**
	 * Switch state by a delta. E.g. current state is 2, jumpState(3) means 
	 * switchState(2+3). Auto loop if the state+delta is out of range.
	 * @param	delta
	 */
	/*public function jumpState(delta:Int):Void
	{
		var toState = state + delta;
		
		if (toState < 0)
			toState += numStates;
			
		if (toState >= numStates)
			toState -= numStates;
			
		switchState(toState);
	}*/
	
	/**
	 * Switch the state. State changes and the corresponding callback is called
	 * immediately if switchMode is SWITCH_MODE_INSTANT. Otherwise the actual 
	 * switching will happen at the end of the animation.
	 */
	public function switchState(state:T):Void
	{
		if (this.state == state)
			return;
		
		//play animation
		var animationName = getAnimationName(this.state, state);		
		if (entity.animation.get(animationName) == null)
		{
			//SWITCH_MODE_ANIMATION_END requires an animation
			switch (switchMode) 
			{
				case SAnimationEnd: throw "Animation named '" + animationName + "' must be set if toggleMode == TOGGLE_MODE_ANIMATION_END";					
				default:					
			}				
		}
		else
			entity.animation.play(animationName);
			
		//Switch the state immediately
		switch (switchMode) 
		{
			case SInstant: internalSwitchState(state);	
			default:					
		}		
	}	
	
	/**
	 * @private
	 * Actually switch the state.
	 */
	private inline function internalSwitchState(state:T):Void
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
		
		if (animationName != null && entity.animation.get(animationName).finished)
		{
			switch (switchMode) 
			{
				case SAnimationEnd:
					var toState:T = cast Type.createEnum(stateType, animationName.split("->")[1]);
					internalSwitchState(toState);
				default:					
			}			
		}		
	}
	
	public function addAnimation(fromState:T, toState:T, frames:Array<Int>, frameRate:Int, reverse:Bool = false):Void
	{
		entity.animation.add(getAnimationName(fromState, toState), frames, frameRate, false);
		
		
		if (reverse)
		{
			var revseredFrames = [for (i in 0...frames.length) frames[frames.length - i - 1]];
			entity.animation.add(getAnimationName(toState, fromState), revseredFrames, frameRate, false);
		}
	}
	
	/**
	 * Connect another stateSwitch to this stateSwitch.
	 * @param	stateSwitch
	 * @param	connectMode
	 */
	public function connect(stateSwitch:StateSwitch<T>, connectMode:ConnectMode):Void
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
	public function disconnect(stateSwitch:StateSwitch<T>):Void
	{
		if (connected.remove(stateSwitch))
			connectModes.remove(stateSwitch);
		
	}
	
	/**
	 * A callback to be called when the state is actually changed to [state]
	 * @param	state
	 * @param	callback
	 */
	public inline function setCallback(state:T, callback:StateSwitch<T>->Void):Void
	{
		callbacks.set(state, callback);
	}
	
	public inline function getAnimationName(fromState:T, toState:T):String
	{
		return Std.string(fromState) + "->" + Std.string(toState);
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

enum SwitchMode 
{
	SInstant;
	SAnimationEnd;
}

enum ConnectMode 
{
	CSync;
	CToggle;
}