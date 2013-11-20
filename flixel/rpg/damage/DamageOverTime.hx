package flixel.rpg.damage;
import flixel.util.FlxTimer;
import flixel.rpg.entity.Entity;
using Lambda;
/**
 * ...
 * @author Kevin
 */
class DamageOverTime
{
	private var pool:Array<FlxTimer>;
	
	public function new()
	{
		pool = [];
	}
	
	public function get(damageType:Int, damage:Int):FlxTimer
	{
		for (t in pool)
		{
			if (t.userData.damageType == damageType && t.userData.damage == damage)
				return t;
		}
		return null;
	}
	
	/**
	 * Create a DOT or extend existing (matching damageType & damage)
	 * @param	character
	 * @param	damageType
	 * @param	damage
	 * @param	interval
	 * @param	ticks
	 */
	public static function create(entity:Entity, damageType:Int, damage:Int, interval:Float, ticks:Int):Void
	{
		var dot = entity.damageOverTime;
		var timer = dot.get(damageType, damage);
		
		if (timer == null)
		{
			timer = FlxTimer.start(interval, onTimerTick , ticks);
			timer.userData = { entity:entity, damageType:damageType, damage:damage };
			dot.add(timer);
		}
		else
		{
			timer.reset(Math.max(interval, timer.timeLeft)); 
		}		
	}
	
	private function add(t:FlxTimer):Void
	{
		pool.push(t);
	}
	
	private function remove(t:FlxTimer):Void
	{
		var i = pool.indexOf(t);
		pool.splice(i, 1);
	}
	
	private static function onTimerTick(t:FlxTimer):Void
	{
		var entity:Entity = t.userData.entity;
		entity.hurt(t.userData.damage);
		
		if (!entity.alive || t.elapsedLoops == t.loops)		
			entity.damageOverTime.remove(t);
			
		if (!entity.alive)
			t.abort();
			
		
	}
	
	public var debug(get, never):String;
	private function get_debug():String
	{
		var result = new Array<String>();
		
		for (t in pool)
			result.push(t.userData.damageType + " - " + t.userData.damage);
		return result.join(",");
	}
}