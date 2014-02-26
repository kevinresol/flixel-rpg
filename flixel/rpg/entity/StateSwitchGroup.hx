package flixel.rpg.entity;
using Lambda;
/**
 * ...
 * @author Kevin
 */
class StateSwitchGroup<T:EnumValue> extends StateSwitch<T>
{
	public var switches:Array<StateSwitch<T>>;
	
	public var groupMode:GroupMode;
	
	public var defaultState:T;
	public var targetState:T;

	public function new(entity:Entity) 
	{		
		super(entity);		
		switches = [];
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

enum GroupMode 
{
	GAnd;//AND mode: all switches have to have the same state
	GOr; //OR mode: Any switches has the targetState
}