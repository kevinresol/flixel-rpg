package flixel.rpg.event;
import flixel.rpg.core.RpgEngine;
import flixel.util.FlxSignal.FlxTypedSignal;

/**
 * ...
 * @author Kevin
 */
class EventManager
{
	private var rpg:RpgEngine;

	public function new(rpg:RpgEngine) 
	{
		this.rpg = rpg;
	}
	
	public function dispatch(id:String):Void
	{
		var data = rpg.data.getEvent(id);
		rpg.scripting.executeScript(data.script);
	}
	
}