package flixel.rpg.core;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.rpg.display.DamageText;
import flixel.rpg.entity.Entity;
import flixel.rpg.entity.Pickup;
import flixel.rpg.level.Level;
import flixel.util.FlxSort;

/**
 * A manager to manage various groups. These groups are then used by RpgEngine to handle collisions
 * @author Kevin
 */
class LevelManager
{
	public var state(default, set):FlxState;
	
	private var levels:Map<String, Level>;
	
	public var current(default, set):Level;
	public var currentName(default, null):String;
	
	public function new()
	{
		levels = new Map<String, Level>();
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
			v.overlay.add(DamageText.group);
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