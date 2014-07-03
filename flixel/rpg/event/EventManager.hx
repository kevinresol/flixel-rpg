package flixel.rpg.event;
import flixel.rpg.core.RpgEngine;
import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * ...
 * @author Kevin
 */
class EventManager
{
	public var conditions(default, null):Map<String, Bool>;
	
	private var rpg:RpgEngine;
	

	public function new(rpg:RpgEngine) 
	{
		this.rpg = rpg;
		
		conditions = new Map();
	}
	
	public function dispatch(id:String):Void
	{
		var data = rpg.data.getEvent(id);
		
		// Only trigger the event if all conditions are fulfilled
		var fulfilled = true;		
		if (data.conditions != null)
		{
			for (condition in data.conditions)
			{
				if (conditions.get(condition) != true)
				{
					fulfilled = false;
					break;
				}
			}
		}
		
		if (fulfilled)
		{
			// execute script
			if (data.script != null)
				rpg.scripting.executeScript(data.script);
			
			// dispatch all the events defined in the data
			if (data.events != null)
			{
				for (event in data.events)
					dispatch(event);
			}
			
			// switch on these conditions
			if (data.on != null)
			{
				for (condition in data.on)
					conditions.set(condition, true);
			}
			
			// switch off these conditions
			if (data.off != null)
			{
				for (condition in data.off)
					conditions.set(condition, false);
			}
		}
	}
	
	public function destroy():Void
	{
		rpg = null;
	}
}