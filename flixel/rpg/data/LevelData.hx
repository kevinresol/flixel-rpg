package flixel.rpg.data;

/**
 * @author Kevin
 */

typedef LevelData =
{
	id:String,
	type:String, // "tiled"
	
	// Tiled
	tmx:String,
	tileset:String,
	layers:Array<String>,
	objectGroups:Array<String>,
}