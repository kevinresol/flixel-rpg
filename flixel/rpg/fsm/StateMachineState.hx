package flixel.rpg.fsm;
import flixel.rpg.entity.Entity;

/**
 * ...
 * @author Kevin
 */
class StateMachineState
{
	public var type:String;
	public var value(default, set):Dynamic;
	
	/**
	 * Change callback
	 * onChange(oldValue, newValue);
	 */
	public var onChange:Dynamic->Dynamic->Void;
	
	public function new() 
	{
		
	}
	
	private function set_value(v:Dynamic):Dynamic
	{
		if (v == value) return v;
		
		if (onChange != null)
			onChange(value, v);
			
		return value = v;
	}
	
	
}