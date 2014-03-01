package flixel.rpg.entity;
import flixel.addons.display.FlxExtendedSprite;
using Lambda;
/**
 * Connect: 2-way communication (Not fully implemented)
 * Group Add: 1-way communication
 * @author Kevin
 */
class StateSwitch<T:EnumValue>
{
	public var entity:Entity;
		
	/**
	 * Switch mode
	 */
	public var switchMode:SwitchMode;
	
	
	/**
	 * Current state
	 */
	public var state(default, null):T;
	
	/**
	 * Runtime value of T
	 */
	private var stateType:Enum<Dynamic>;
	
	/**
	 * A function to be called when state changed
	 */
	public var onStateSwitched:StateSwitch<T>->Void;
	
	/**
	 * A StateSwitchGroup can contain serveral StateSwitches
	 * And a StateSwitch can be conatined by serveral StateSwitchGroups
	 * This array stores the groups containing [this]
	 */
	public var groups:Array<StateSwitch<T>>;
	
	
	/**
	 * An array of connected toggles.
	 */
	private var connected:Array<StateSwitch<T>>; //TODO
	
	private var connectModes:Map < StateSwitch<T>, ConnectMode > ;
	
	
	/**
	 * 
	 */
	public var groupMode:GroupMode;
	
	/**
	 * Contained switches (only relevant when groupMode != GNone)
	 */
	public var switches:Array<StateSwitch<T>>;	
	
	/**
	 * Default state (only relevant when groupMode != GNone)
	 */
	public var defaultState:T;
	
	/**
	 * Target state (only relevant when groupMode != GNone)
	 */
	public var targetState:T;
	
	/**
	 * Constructor
	 * @param	x
	 * @param	y
	 */
	public function new(entity:Entity, defaultState:T, ?targetState:T, ?groupMode:GroupMode) 
	{
		this.entity = entity;
		
		switchMode = SInstant;
		
		state = defaultState;
		stateType = Type.getEnum(state);
		
		this.groupMode = (groupMode == null ? GNone : groupMode);
		
		entity.animation.callback = animationCallback;		
		connectModes = new Map<StateSwitch<T>, ConnectMode>();
			
		connected = [];
		groups = [];
		
		// Some group-mode-only settings
		switch(this.groupMode)
		{
			case GNone:
			default:
				switches = [];
				this.targetState = targetState;
				this.defaultState = defaultState;
		}
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
		
		//Callback	
		if (onStateSwitched != null)
			onStateSwitched(this);
		
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
		if (connected.indexOf(stateSwitch) >= 0)
			return;
			
		connected.push(stateSwitch);
		connectModes.set(stateSwitch, connectMode);
		
		stateSwitch.connect(this, connectMode);		
	}
	
	/**
	 * Disconnect a connected stateSwitch.
	 * @param	stateSwitch
	 */
	public function disconnect(stateSwitch:StateSwitch<T>):Void
	{		
		if (!connected.remove(stateSwitch))
			return;
			
		connectModes.remove(stateSwitch);
			
		stateSwitch.disconnect(this);	
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
	
	/**
	 * Notify the groups containing [this]. Called when state actually changed.
	 */
	public function notifyConnected():Void
	{
		
	}
	
	/**
	 * Add a StateSwitch to this group
	 * @param	stateSwitch
	 */
	public function addSwitch(stateSwitch:StateSwitch<T>):Void
	{
		var index = switches.indexOf(stateSwitch);
		if (index == -1)
		{
			switches.push(stateSwitch);
			stateSwitch.groups.push(this);
		}
	}
	
	/**
	 * Remove a StateSwitch from this group
	 * @param	stateSwitch
	 */
	public function removeSwitch(stateSwitch:StateSwitch<T>):Void
	{
		switches.remove(stateSwitch);
		stateSwitch.groups.remove(this);
	}
	
	/**
	 * Check all child switches and determine the state of this group
	 */
	public function checkSwitches():Void
	{		
		switch (groupMode) 
		{
			case GNone:
			case GAnd:
				var prevSwitch:StateSwitch<T> = null;
				
				for (s in switches)
				{					
					if (prevSwitch != null && prevSwitch.state != s.state)	
					{
						//Switch off if all of them are different
						switchState(defaultState);
						return;
					}
						
					prevSwitch = s;
				}
				
				switchState(prevSwitch.state);
				
			case GOr:
				for (s in switches)
				{
					if (s.state == targetState)
					{
						switchState(targetState);
						return;
					}
				}
				//switch off if none of the children are at targetState
				switchState(defaultState);	
		}	
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

enum GroupMode 
{
	GNone; //Not a group
	GAnd;//AND mode: all switches have to have the same state
	GOr; //OR mode: Any switches has the targetState
}