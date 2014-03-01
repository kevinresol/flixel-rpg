package flixel.rpg.level;

import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

/**
 * ...
 * @author Kevin
 */
class Level
{
	public var background:FlxTilemap;	
	public var obstacles(default, null):FlxTilemap;
	public var overlay:FlxTilemap;

	public function new() 
	{
		
		background = new FlxTilemap();
		obstacles = new FlxTilemap();		
		overlay = new FlxTilemap();
		//add(overlays);
	}
	
	
	
}