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
		entity.health = data.health;
		
		if (data.maxVelocity != null)
			entity.maxVelocity.set(data.maxVelocity.x, data.maxVelocity.y);
		
		// hitbox
		if(data.hitbox != null)
			entity.setSize(data.hitbox.width, data.hitbox.height);
		
		// graphics and animations
		entity.loadGraphic(data.graphic.asset, false, data.graphic.width, data.graphic.height);
		
		if (data.graphic.centerOffsets == true) 
			entity.centerOffsets();
			
		if (data.graphic.animations != null)
		{
			for(animation in data.graphic.animations)
				entity.animation.add(animation.name, animation.frames, animation.frameRate, animation.looped);
			entity.animation.play(data.graphic.defaultAnimation);
		}
		
		// AI
		if (data.ai != null)
		{
			entity.enableAI();
			for (ai in data.ai)
			{
				entity.ai.add(ai.name, Type.createInstance(Type.resolveClass(ai.className), ai.params));
			}
		}
		
		// run script
		var path = 'assets/data/scripts/$id.hs';
		if (Assets.exists(path))
			entity.executeScript(Assets.getText(path));
		
		return entity;
	}
	
}