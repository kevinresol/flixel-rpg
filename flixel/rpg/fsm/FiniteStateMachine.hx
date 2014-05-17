package flixel.rpg.fsm;
import flixel.rpg.entity.Entity;
import flixel.util.FlxSignal;

/**
 * ...
 * @author Kevin
 */
//@:generic
class FiniteStateMachine<T:EnumValue>
{	
	public var currentState(default, set):T;
	
	/**
	 * Parameters: newState, oldState
	 */
	public var changed(default, null):FlxTypedSignal<T->T->Void>;
	
	
	public function new() 
	{
		changed = new FlxTypedSignal();
	}
	
	private function set_currentState(v:T):T
	{
		if (v == currentState)
			return currentState;
			
		changed.dispatch(v, currentState);
			
		return currentState = v;
			
	}
}