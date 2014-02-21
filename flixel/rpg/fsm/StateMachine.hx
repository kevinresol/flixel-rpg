package flixel.rpg.fsm;

/**
 * ...
 * @author Kevin
 */
class StateMachine
{
	public var states:Map<String, StateMachineState>;
	
	public function new() 
	{
		states = new Map<String, StateMachineState>();
	}
	
	public function set(type:String, state:StateMachineState):Void
	{
		if (states.exists(type))
			throw '$name already set';
		else
			states.set(type, state);
	}
	
	public function get(type:String):StateMachineState
	{
		return states.get(type);
	}
}