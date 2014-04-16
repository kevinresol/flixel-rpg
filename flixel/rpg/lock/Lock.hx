package flixel.rpg.lock;
import flixel.util.FlxSignal;
/**
 * ...
 * @author Kevin
 */
class Lock
{
	public var isLocked:Bool;
	
	public var locked(default, null):FlxTypedSignal<Bool->Void>;
	
	public function new() 
	{
		isLocked = true;
		locked = new FlxTypedSignal();
	}
	
	public inline function lock():Void
	{
		if (!isLocked)
		{
			isLocked = true;
			locked.dispatch(isLocked);
		}
	}
	
	public inline function unlock():Void
	{
		if (isLocked)
		{
			isLocked = false;
			locked.dispatch(isLocked);
		}
	}
	
}