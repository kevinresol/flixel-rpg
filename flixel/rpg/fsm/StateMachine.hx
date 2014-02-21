package flixel.rpg.fsm;
import flixel.rpg.entity.Entity;

/**
 * ...
 * @author Kevin
 */
class StateMachine
{
	public var entity(default, null):Entity;
	public var states:Map<String, StateMachineState>;
	
	public function new(entity) 
	{
		this.entity = entity;
		states = new Map<String, StateMachineState>();
	}
	
	public function set(type:String, state:StateMachineState):Void
	{
		if (states.exists(type))
			throw '$type already set';
		else
			states.set(type, state);
	}
	
	public function get(type:String):StateMachineState
	{
		return states.get(type);
	}
}