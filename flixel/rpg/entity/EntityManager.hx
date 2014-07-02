package flixel.rpg.entity;
import flixel.rpg.core.RpgEngine;
import openfl.Assets;

/**
 * ...
 * @author Kevin
 */
class EntityManager
{
	private var entities:Map<String, Entity>;

	public function new() 
	{
		entities = new Map();
	}
	
	/**
	 * Create an entity from data
	 * @param	id			the ID to identify the data
	 * @param	x
	 * @param	y
	 * @param	gameId 		the in-game ID, for identifying the created entity instance later
	 * @return
	 */
	public function create(id:String, x:Float = 0, y:Float = 0, gameId:String = ""):Entity
	{
		var data = RpgEngine.data.getEntity(id);
		var entity = new Entity(x, y);
		
		// basic properties		
		entity.immovable = data.immovable;
		entity.health = data.health;
		
		if (data.maxVelocity != null)
			entity.maxVelocity.set(data.maxVelocity.x, data.maxVelocity.y);
			
		entity.force = switch (data.force) 
		{
			case "ally": FAlly;
			case "enemy": FEnemy;
			case "player": FPlayer;
			default: FNeutral;
		}
		
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
		
		// Dialog
		if (data.dialog != null)
		{
			entity.enableDialogueInitializer();
			entity.dialogInitializer.script = data.dialog;
		}
		
		// run script
		var path = 'assets/data/scripts/$id.hs';
		if (Assets.exists(path))
			entity.executeScript(Assets.getText(path));
		
		// add to pool
		if (gameId != "")
			register(gameId, entity);
		
		return entity;
	}
	
	public function get(id:String):Entity
	{
		return entities.get(id);
	}
	
	public function register(id:String, entity:Entity):Void
	{
		if (entities.exists(id))
			FlxG.log.warn('EntityManager#register: Entity of the id: $id already exists');
		entities.set(id, entity);
	}
	
	public function unregister(id:String):Entity
	{
		var entity = entities.get(id);
		if (entity != null)
			entities.remove(id);
		return entity;
	}
}