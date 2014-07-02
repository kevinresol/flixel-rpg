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
	layer:String,
	objectGroup:String,
}