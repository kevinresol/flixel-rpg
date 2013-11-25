package flixel.rpg.stat;

/**
 * ...
 * @author Kevin
 */
class StatController
{
	
	private var stats:Map<String, Stat>;
	private var modifiers:Map<String, StatModifier>;

	public function new() 
	{
		stats = new Map<String, Stat>();
		modifiers = new Map<String, StatModifier>();
	}
	
	public function addStat(name:String, intrinsicValue:Int, maxValue:Int, minValue:Int):Stat
	{
		if (stats.exists(name))
			throw "Stat name already exist";
		
		var s = new Stat(intrinsicValue, maxValue, minValue);
		stats.set(name, s);
		validateStats();
		return s;
	}
	
	public function removeStat(name:String, destroy:Bool = true):Void
	{
		var s = stats.get(name);
		stats.remove(name);
		if (destroy) s.destroy();
		validateStats();
	}
	
	public function getStat(name:String):Stat
	{
		return stats.get(name);
	}
	
	public function addModifier(name:String, modiferFunction:Stat->Stat->Void, ?modfiedStat:Stat, ?modfierStat:Stat):StatModifier
	{
		if (modifiers.exists(name))
			throw "Modifier name already exist";
			
		var m = new StatModifier(modiferFunction, modfiedStat, modfierStat);
		modifiers.set(name, m);
		validateStats();
		return m;
	}
	
	public function removeModifier(name:String, destroy:Bool = true):Void
	{
		var m = modifiers.get(name);
		modifiers.remove(name);
		if (destroy) m.destroy();
		validateStats();
	}
	
	public function getModifier(name:String):StatModifier
	{
		return modifiers.get(name);
	}
	
	
	public function validateStats():Void 
	{
		for (s in stats)
			s.validate();		
	}
	
	public function destroy():Void
	{
		for (m in modifiers)
			m.destroy();
			
		for (s in stats)
			s.destroy();
		
		modifiers = null;
		stats = null;
	}
}