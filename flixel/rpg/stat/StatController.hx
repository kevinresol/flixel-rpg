package flixel.rpg.stat;

/**
 * ...
 * @author Kevin
 */
class StatController
{
	
	private var stats:Map<String, Stat>;

	public function new() 
	{
		stats = new Map<String, Stat>();
	}
	
	public function add(name:String, intrinsicValue:Int, maxValue:Int, minValue:Int):Stat
	{
		if (stats.exists(name))
			throw "Stat name already exist";
		
		var stat = new Stat(intrinsicValue, maxValue, minValue);
		stats.set(name, stat);
		return stat;
	}
	
	public function get(name:String):Stat
	{
		return stats.get(name);
	}
	
	public function validateStats():Void 
	{
		for (s in stats)
			s.validate();		
	}
}