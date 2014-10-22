package flixel.rpg.ai;
import flixel.rpg.ai.AI.IAI;
import flixel.rpg.entity.Entity;
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
	private var aiList:Map<String, IAI>;
	
	private var aiArray:Array<IAI>;
	
	/**
	 * Contructor
	 * @param	entity
	 */
	public function new(entity:Entity) 
	{
		this.entity = entity;
		
		aiList = new Map<String, IAI>();
		aiArray = [];
	}
	
	/**
	 * Add an AI
	 * @param	aiName
	 * @param	ai
	 * @return	the added AI
	 */
	public function add(aiName:String, ai:IAI):IAI
	{
		ai.entity = entity;
		
			
		if (aiList.exists(aiName))
			throw "This name has already been used";
		
		if (aiList.has(ai))
			throw "This AI has already been added";
		
		aiList.set(aiName, ai);
		aiArray.push(ai);
		
		return ai;
	}
	
	/**
	 * Remove an AI
	 * @param	aiName
	 */
	public function remove(aiName:String):Void
	{
		var ai = aiList.get(aiName);
		
		if (ai != null)
		{
			ai.entity = null;		
			aiList.remove(aiName);
			aiArray.remove(ai);
		}
	}
	
	/**
	 * Get an AI
	 * @param	aiName
	 * @return
	 */
	public function get(aiName:String):IAI
	{
		if (aiList == null)
			return null;
		
		return aiList.get(aiName);
	}
	
	/**
	 * Called by the entity's update() function
	 */
	public function update(elapsed:Float):Void
	{		
		for (ai in aiArray)
			ai.update(elapsed);
	}
	
	/**
	 * Called by the entity's destroy() function
	 */
	public function destroy():Void
	{
		for (ai in aiArray)
			ai.destroy();
		
		aiList = null;
		aiArray = null;
	}
	
}