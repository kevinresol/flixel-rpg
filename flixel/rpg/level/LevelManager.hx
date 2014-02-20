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
	
	public var currentName(default, null):String;
	public var current(default, null):Level;

	public function new() 
	{
		levels = new Map<String, Level>();
	}
	
	/**
	 * Register a level to this manager. A level must be registered before it can be switched to.
	 * @param	name
	 * @param	level
	 */
	public function register(name:String, level:Level):Void
	{
		if (levels.exists(name))
			FlxG.log.warn('LevelManager.registerLevel: Level name "$name" already exists');
			
		levels.set(name, level);
	}
	
	/**
	 * Switch to a level
	 * @param	name
	 */
	public function switchTo(name:String):Void
	{
		var level = levels.get(name);
		
		if (level == null)
			throw 'LevelManager.switchLevel: Level name "$name" does not exist"';
		
		current = level;
		currentName = name;
		
		RpgEngine.groups.registerLevel(level);
	}	
}