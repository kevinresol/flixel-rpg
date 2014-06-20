package flixel.rpg.entity;
import flixel.rpg.core.RpgEngine;
import openfl.Assets;

/**
 * ...
 * @author Kevin
 */
class EntityManager
{

	public function new() 
	{
		
	}
	
	public function create(id:String, x:Float = 0, y:Float = 0):Entity
	{
		var data = RpgEngine.data.getEntity(id);
		var entity = new Entity(x, y);
		
		// basic properties
		entity.immovable = data.immovable;
		
		// hitbox
		if(data.hitbox != null)
			entity.setSize(data.hitbox.width, data.hitbox.height);
		
		// graphics and animations
		entity.loadGraphic(data.graphic.asset, false, data.graphic.width, data.graphic.height);
		if (data.graphic.animations != null)
		{
			for(animation in data.graphic.animations)
				entity.animation.add(animation.name, animation.frames, animation.frameRate, animation.looped);
			entity.animation.play(data.graphic.defaultAnimation);
		}
		
		// run script
		if (Assets.exists('assets/data/scripts/$id.hs'))
		{
			var script = Assets.getText('assets/data/scripts/$id.hs');
			entity.executeScript(script);
		}
		
		return entity;
	}
	
}