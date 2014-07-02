package flixel.rpg.core;
import flixel.FlxG;
import flixel.FlxState;
import flixel.rpg.data.LevelData;
import flixel.rpg.display.DamageText;
import flixel.rpg.level.Level;
import flixel.rpg.level.TiledLevel;

/**
 * A manager to manage various groups. These groups are then used by RpgEngine to handle collisions
 * @author Kevin
 */
class LevelManager
{
	public var state(default, set):FlxState;
	
	private var levels:Map<String, Level>;
	private var rpg:RpgEngine;
	
	public var current(default, set):Level;
	public var currentName(default, null):String;
	
	public function new(rpg:RpgEngine)
	{
		this.rpg = rpg;
		levels = new Map<String, Level>();
	}
	
	public function init():Void
	{
		if (rpg.data.level == null)
			throw "Level data not set. Use `RpgEngine.data.level = somedata;`";
	
		for (data in rpg.data.level)
		{
			register(data.id, create(data));
		}
	}
	
	public function create(data:LevelData):Level
	{
		switch(data.type)
		{
			case "tiled":
				var level = new TiledLevel();
				level.loadTmx(data.tmx, data.tileset, data.layer, data.objectGroup);
				return level;
				
			default:
				
		}
		
		return null;
	}
	
	public function register(name:String, level:Level):Void
	{
		levels.set(name, level);
	}
	
	public function switchTo(name:String):Void
	{
		var level = levels.get(name);
		
		if (level == null)
			FlxG.log.warn("No Level registered under the name: " + name);
		else
		{
			current = level;
			currentName = name;
		}
	}
	
	public function destroy():Void
	{
		state = null;
		rpg = null;
		
		for (level in levels)
			level.destroy();
		
		levels = null;
	}
	
	private function set_current(v:Level):Level
	{
		if (current != null && state != null)
		{
			state.remove(current);
			current.overlay.remove(DamageText.group);
		}
		
		if (v != null && state != null)
		{
			state.add(v);			
			//v.overlay.add(DamageText.group); //FIXME temporarily disable
		}
		
		return current = v;
	}
	
	private function set_state(v:FlxState):FlxState
	{
		if (state != null && current != null)
		{
			state.remove(current);
		}
		
		if (v != null && current != null)
		{
			v.add(current);
		}
		
		return state = v;
	}
}