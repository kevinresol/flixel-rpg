package flixel.rpg.entity;

using Lambda;

/**
 * A 2-state StateSwitch
 * @author Kevin
 */
class Toggle extends StateSwitch
{
	public static inline var ON:Int = 1;
	public static inline var OFF:Int = 0;
	
	public static inline var CONNECT_MODE_TOGGLE:Int = 0;
	public static inline var CONNECT_MODE_SYNC:Int = 1;		
	
	/**
	 * Constructor
	 * @param	x
	 * @param	y
	 */
	public function new(x:Float=0, y:Float=0) 
	{
		super(x, y, 2);
	}
	
	public inline function toggle():Void
	{
		jumpState(1);
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