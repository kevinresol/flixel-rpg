package flixel.rpg.damage;
import flixel.util.FlxTimer;
import flixel.rpg.entity.Entity;
using Lambda;
/**
 * A helper class that cause damage periodically to entities
 * TODO: rework the whole flow (currently it is confused, DOT is centeralized? or localized (in an entity?), see onTimerTick)
 * @author Kevin
 */
class DamageOverTime
{
	/**
	 * @private
	 * A pool of FlxTimer, which is used to cause damage periodically
	 */
	private var pool:Array<FlxTimer>;
	
	/**
	 * Constructor
	 */
	public function new()
	{
		pool = [];
	}
	
	/**
	 * Return a damage timer of the specified damageType and damage
	 * @param	damageType
	 * @param	damage
	 * @return
	 */
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
	 * @param	entity
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
	
	/**
	 * @private
	 * Internal function to add a timer to the pool
	 * @param	timer
	 */
	private function add(timer:FlxTimer):Void
	{
		pool.push(timer);
	}
	
	/**
	 * @private
	 * Internal function to remove a timer from the pool
	 * @param	timer
	 */
	private function remove(timer:FlxTimer):Void
	{
		var i = pool.indexOf(timer);
		pool.splice(i, 1);
	}
	
	/**
	 * @private	
	 * Callback for a damage timer. Inflict damage to the entity
	 * @param	t
	 */
	private static function onTimerTick(t:FlxTimer):Void
	{
		var entity:Entity = t.userData.entity;
		entity.hurt(t.userData.damage);
		
		//remove the timer if entity is dead or finished all ticks
		if (!entity.alive || t.elapsedLoops == t.loops)		
			entity.damageOverTime.remove(t);
		
		
		if (!entity.alive)
			t.abort();
			
		
	}
	
	/**
	 * Debug string
	 * @return
	 */
	private function toString():String
	{
		var result = new Array<String>();
		
		for (t in pool)
			result.push(t.userData.damageType + " - " + t.userData.damage);
		return result.join(",");
	}
}