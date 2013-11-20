package flixel.rpg.level;

import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

/**
 * ...
 * @author Kevin
 */
class Level extends FlxGroup
{
	public var blocks:FlxTilemap;
	public var overlays:FlxTilemap;

	public function new() 
	{
		super();		
		
		blocks = new FlxTilemap();
		add(blocks);
		
		overlays = new FlxTilemap();
		//add(overlays);
	}
	
	
	
}