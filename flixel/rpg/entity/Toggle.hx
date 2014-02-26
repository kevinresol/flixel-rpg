package flixel.rpg.entity;

using Lambda;

/**
 * A 2-state StateSwitch
 * @author Kevin
 */
class Toggle extends StateSwitch<ToggleState>
{	
	/**
	 * Constructor
	 * @param	x
	 * @param	y
	 */
	public function new(entity:Entity) 
	{
		super(entity);
	}
	
	public inline function toggle():Void
	{
		switch(this.state)
		{
			case TOn: switchState(TOff);
			case TOff: switchState(TOn);				
		}
	}
	
	/**
	 * Toggle connected toggles.
	 */
	/*private inline function toggleConnected():Void
	{
		for (toggle in connected)
		{
			var connectMode = connectModes.get(toggle);
			
			if(connectMode == CONNECT_MODE_TOGGLE || (connectMode == CONNECT_MODE_SYNC && toggle.status != status))
				toggle.toggle();
			
		}
	}	*/	
	
}

enum ToggleState 
{
	TOn;
	TOff;
}