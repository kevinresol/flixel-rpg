package flixel.rpg.level;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.rpg.core.RpgEngine;
import haxe.io.Path;
import openfl.Assets;

/**
 * Tailor-made Level for the map editor "Tiled".
 * http://www.mapeditor.org/
 * @author Kevin
 */

class TiledLevel extends Level
{
	public function new() 
	{
		super();		
	}
	
	public function loadTmx(tmxPath:String, tilesetName:String, layerName:String, objectGroupName:String):Void
	{
		// Load tmx
		var tmx = new TiledMap(tmxPath);
		
		// Tileset & image path
		var tileset = tmx.getTileSet(tilesetName);
		var imagePath = Path.normalize(Path.directory(tmxPath) + "/" + tileset.imageSource);
		
		// Load map
		var layer = tmx.getLayer(layerName);
		var mapArray = layer.tileArray.map(function(v) return v - 1); //The numbering in the data array starts from 1, but we want 0
		obstacles.widthInTiles = layer.width;
		obstacles.heightInTiles = layer.height;		
		obstacles.loadMap(mapArray, imagePath, tileset.tileWidth, tileset.tileHeight, OFF, 0, 1, 2);
				
		// Load Objects
		var objectGroup = tmx.getObjectGroup(objectGroupName);
		loadObjects(objectGroup);
	}
	
	private function loadObjects(objectGroup:TiledObjectGroup):Void
	{
		for (o in objectGroup.objects)
		{
			var entity = RpgEngine.entities.create(o.type, o.x, o.y, o.name);
			switch (entity.force) 
			{
				case FPlayer: registerAlly(entity); registerPlayer(entity);
				case FAlly: registerAlly(entity);
				case FEnemy: registerEnemy(entity);
				case FNeutral: registerNeutral(entity);
			}
			objects.add(entity);
		}
	}	
}
