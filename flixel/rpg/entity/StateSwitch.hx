package flixel.rpg.entity;
import flixel.addons.display.FlxExtendedSprite;
import flixel.rpg.fsm.FiniteStateMachine;
import flixel.util.FlxSignal;
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
	public var switchMode:SwitchMode = SInstant;
	
	/**
	 * Current state
	 */
	public var state(get, set):T;
	
	private var stateMachine:FiniteStateMachine<T>;
	
	/**
	 * Runtime value of T
	 */
	private var stateType:Enum<Dynamic>;	
	
	/**
	 * An array of connected toggles.
	 */
	private var connected:Array<StateSwitch<T>>; //TODO
	
	private var connectModes:Map<StateSwitch<T>, ConnectMode>;	
	
	/**
	 * 
	 */
	public var groupMode:GroupMode<T> = GNone;
	
	/**
	 * Contained switches (only relevant when groupMode != GNone)
	 */
	public var switches:Array<StateSwitch<T>>;		
	
	public var changed(get, never):FlxTypedSignal<T->T->Void>;
	
	/**
	 * 
	 * @param	entity
	 * @param	defaultState
	 * @param	groupMode GNone: Not a group
	 */
	public function new(entity:Entity, initialState:T, ?groupMode:GroupMode<T>) 
	{
		this.entity = entity;
		
		stateMachine = new FiniteStateMachine<T>();
		
		//switchMode = SInstant;
		
		state = initialState;
		stateType = Type.getEnum(state);
		
		if(groupMode != null)
			this.groupMode = groupMode;
		
		entity.animation.callback = animationCallback;		
		connectModes = new Map<StateSwitch<T>, ConnectMode>();
			
		connected = [];
		
		// Some group-mode-only settings
		switch (this.groupMode)
		{
			case GNone:
			default:
				switches = [];
		}
	}	
	
	/**
	 * Switch the state. State changes and the corresponding callback is called
	 * immediately if switchMode is SWITCH_MODE_INSTANT. Otherwise the actual 
	 * switching will happen at the end of the animation.
	 */
	public function switchState(toState:T):Void
	{
		if (state == toState)
			return;
		
		//play animation
		var animationName = getAnimationName(state, toState);		
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
			case SInstant: state = toState;
			default:					
		}		
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
					state = toState;
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
	 * Add a StateSwitch to this group
	 * @param	stateSwitch
	 */
	public function addSwitch(stateSwitch:StateSwitch<T>):Void
	{
		if (groupMode == GNone)
			throw "This stateSwitch is not configured as a group. Set groupMode to non-GNone values";
		
		var index = switches.indexOf(stateSwitch);
		if (index == -1)
		{
			switches.push(stateSwitch);
			stateSwitch.changed.add(onChildChanged);
		}
	}
	
	/**
	 * Remove a StateSwitch from this group
	 * @param	stateSwitch
	 */
	public function removeSwitch(stateSwitch:StateSwitch<T>):Void
	{
		if (groupMode == GNone)
			throw "This stateSwitch is not configured as a group. Set groupMode to non-GNone values";
		
		switches.remove(stateSwitch);
		stateSwitch.changed.remove(onChildChanged);
	}	
	
	private function onChildChanged(_,_):Void
	{
		switch (groupMode) 
		{
			case GNone:
			case GAnd(defaultState):
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
				
			case GOr(defaultState, targetState):
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
				
			case GPattern(pattern, defaultState, targetState):
				//TODO pattern
		}	
	}
	
	private function get_state():T
	{
		return stateMachine.currentState;
	}
	
	private function set_state(v:T):T
	{
		return stateMachine.currentState = v;
	}
	
	private function get_changed():FlxTypedSignal<T->T->Void>
	{
		return stateMachine.changed;
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

enum GroupMode<T>
{
	GNone; // Not a group
	GAnd(defaultState:T); // AND mode: all switches have to have the same state
	GOr(defaultState:T, targetState:T); // OR mode: Any switches has the targetState
	GPattern(pattern:Array<T>, defaultState:T, targetState:T); // Pattern mode: switch to target state if the pattern is fulfilled
}