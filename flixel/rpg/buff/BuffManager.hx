package flixel.rpg.buff;
import flixel.rpg.entity.Entity;
import flixel.util.FlxArrayUtil;

/**
 * ...
 * @author Kevin
 */
class BuffManager
{
	private var entity:Entity;
	
	private var buffs:Array<Buff>;

	public function new(entity:Entity) 
	{
		this.entity = entity;
		buffs = [];
	}
	
	public function add(buff:Buff):Void
	{
		if (buffs.indexOf(buff) == -1)
		{
			buffs.push(buff);
			buff.entity = entity;
			
			if(buff.applyCallback != null)
				buff.applyCallback(buff);			
		}
	}
	
	public function remove(buff:Buff):Void
	{		
		var index = buffs.indexOf(buff);
		if (index != -1)
		{
			FlxArrayUtil.swapAndPop(buffs, index);
			
			if(buff.unapplyCallback != null)
				buff.unapplyCallback(buff);
				
			buff.destroy();
		}
	}
	
	public function update():Void
	{
		var i = buffs.length;
		
		while (--i >= 0)
		{
			var buff = buffs[i];
			
			if (buff.timeLeft <= 0)
				FlxArrayUtil.swapAndPop(buffs, i);
			else
				buff.update();			
		}
	}
}