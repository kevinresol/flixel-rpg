package flixel.rpg.buff;

/**
 * ...
 * @author Kevin
 */
class TickerBuff extends Buff
{
	public var tickCallback:Buff->Void;
	public var tickInterval:Float;
	
	private var elapsed:Float;

	public function new(type:String, level:Int, time:Float, applyCallback:Buff->Void, unapplyCallback:Buff->Void, tickInterval:Float, tickCallback:Buff->Void)
	{
		super(type, level, time, applyCallback, unapplyCallback);
		this.tickCallback = tickCallback;
		this.tickInterval = tickInterval;
	}
	
	override public function update()
	{
		super.update();
		
		elapsed += FlxG.elapsed;
		
		if (elapsed >= tickInterval)
		{
			elapsed -= tickInterval;
			tickCallback();
		}
	}
	
}