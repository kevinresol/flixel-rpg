package flixel.rpg.entity;
using Lambda;
/**
 * ...
 * @author Kevin
 */
class StateSwitchGroup extends StateSwitch
{
	public var switches:Array<StateSwitch>;
	
	public var groupMode:Int;
	
	public static inline var GROUP_MODE_AND:Int = 0;
	public static inline var GROUP_MODE_OR:Int = 1;
	
	public var targetState:Int = 0;

	public function new(x:Float=0, y:Float=0, numState:Int = 2) 
	{
		
		super(x, y, numStates);		
		switches = [];
	}
	
	/**
	 * Add a StateSwitch to this group
	 * @param	stateSwitch
	 */
	public function addSwitch(stateSwitch:StateSwitch):Void
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
	public function removeSwitch(stateSwitch:StateSwitch):Void
	{
		switches.remove(stateSwitch);
		stateSwitch.groups.remove(this);
	}
	
	/**
	 * Check all child switches and determine the state of this group
	 */
	public function checkSwitches():Void
	{
		//AND mode: all switches have to have the same state
		if (groupMode == GROUP_MODE_AND)
		{
			var prevSwitch:StateSwitch = null;
			
			for (s in switches)
			{					
				if (prevSwitch != null && prevSwitch.state != s.state)	
				{
					//Switch off if all of them are different
					switchState(0);
					return;
				}
					
				prevSwitch = s;
			}
			
			switchState(prevSwitch.state);				
		}
		//OR mode: Any switches has the targetState
		else if (groupMode == GROUP_MODE_OR)
		{
			for (s in switches)
			{
				if (s.state == targetState)
				{
					switchState(targetState);
					return;
				}
			}
			//switch off if none of the children are at targetState
			switchState(0);
		}		
	}
	
	
	
}