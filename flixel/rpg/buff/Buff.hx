package flixel.rpg.buff;
import flixel.rpg.entity.Entity;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * ...
 * @author Kevin
 */
class Buff implements IFlxDestroyable
{
	public var type:String;
	public var level:Int;
	
	public var timeLeft:Float = 0;
	
	
	/**
	 * Called when the buff starts to be in effect
	 */
	public var applyCallback:Buff->Void;
	
	/**
	 * Called when the buff ceases to be in effect
	 */
	public var unapplyCallback:Buff->Void;
	
	@:allow(flixel.rpg.buff.BuffManager)
	private var entity:Entity;

	public function new(type:String, level:Int, time:Float, applyCallback:Buff->Void, unapplyCallback:Buff->Void )
	{
		this.type = type;
		this.level = level;
		this.timeLeft = time;
		this.applyCallback = applyCallback;
		this.unapplyCallback = unapplyCallback;
	}
	
	public function update()
	{
		timeLeft -= FlxG.elapsed;	
	}
	
	public function destroy() 
	{
		applyCallback = null;
		unapplyCallback = null;
		entity = null;
	}
}