package flixel.rpg.buff;

/**
 * ...
 * @author Kevin
 */
class DOTBuff extends TickerBuff
{
	public var damage:Float;

	public function new(type:String, level:Int, time:Float, tickInterval:Float, damage:Float)
	{
		super(type, level, time, null, null, tickInterval, dotTick);
		this.damage = damage;
	}
	
	private function dotTick():Void
	{
		entity.hurt(damage);
	}	
}