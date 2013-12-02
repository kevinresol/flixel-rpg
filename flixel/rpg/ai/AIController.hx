package flixel.rpg.ai;
import flixel.FlxSprite;
import flixel.rpg.entity.Entity;
import flixel.rpg.ai.AI;
using Lambda;
/**
 * A front end to control various AI for the entity
 * @author Kevin
 */
class AIController
{
	/**
	 * @private
	 * The parent entity
	 */
	private var entity:Entity;
	
	/**
	 * @private
	 * List of the added AI's
	 */
	private var aiList:Map<String, AI>;
	
	/**
	 * Contructor
	 * @param	entity
	 */
	public function new(entity:Entity) 
	{
		this.entity = entity;
	}
	
	/**
	 * Add an AI
	 * @param	aiName
	 * @param	ai
	 */
	public function add(aiName:String, ai:AI):Void
	{
		ai.entity = entity;
		
		if (aiList == null)
			aiList = new Map<String, AI>();
			
		if (aiList.exists(aiName))
			throw "This name has already been used";
		
		if (aiList.has(ai))
			throw "This AI has already been added";
		
		aiList.set(aiName, ai);
	}
	
	/**
	 * Remove an AI
	 * @param	aiName
	 */
	public function remove(aiName:String):Void
	{		
		if (aiList == null)
			return;			
		
		var ai = aiList.get(aiName);
		
		if (ai != null)
		{
			ai.entity = null;		
			aiList.remove(aiName);
		}
	}
	
	/**
	 * Get an AI
	 * @param	aiName
	 * @return
	 */
	public function get(aiName:String):AI
	{
		if (aiList == null)
			return null;
		
		return aiList.get(aiName);
	}
	
	/**
	 * Called by the entity's update() function
	 */
	public function update():Void
	{
		if (aiList == null)
			return;			
			
		for (ai in aiList)
			ai.update();
	}
	
	/**
	 * Called by the entity's destroy() function
	 */
	public function destroy():Void
	{
		if (aiList == null)
			return;	
			
		for (ai in aiList)
			ai.destroy();
		
		aiList = null;
	}
	
}