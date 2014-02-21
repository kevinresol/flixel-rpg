package flixel.rpg.requirement;
import flixel.rpg.fsm.StateMachine;

/**
 * ...
 * @author Kevin
 */
class StateRequirement implements IRequirement
{
	private var stateMachine:StateMachine;
	
	private var type:String;
	
	private var value:String;

	public function new(type:String, value:Dynamic, stateMachine:StateMachine) 
	{
		this.type = type;
		this.value = value;
		this.stateMachine = stateMachine;
	}
	
	/* INTERFACE flixel.rpg.requirement.IRequirement */
	
	public function fulfilled():Bool 
	{			
		return stateMachine != null && stateMachine.get(type) == value;
	}
	
}