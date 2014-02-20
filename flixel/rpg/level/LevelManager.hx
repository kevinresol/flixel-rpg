package flixel.rpg.level;
import flixel.FlxG;
import flixel.rpg.core.RpgEngine;

/**
 * ...
 * @author Kevin
 */
class LevelManager
{
	private var levels:Map<String, Level>;

	public function new() 
	{
		levels = new Map<String, Level>();
	}
	
	public function registerLevel(name:String, level:Level):Void
	{
		if (levels.exists(name))
			FlxG.log.warn('LevelManager.registerLevel: Level name "$name" already exists');
			
		levels.set(name, level);
	}
	
	public function switchLevel(name:String):Void
	{
		var level = levels.get(name);
		
		if (level == null)
			throw 'LevelManager.switchLevel: Level name "$name" does not exist"';
		
		RpgEngine.groups.registerLevel(level);
	}
	
}