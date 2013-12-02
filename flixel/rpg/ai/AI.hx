package flixel.rpg.ai;
import flixel.FlxSprite;
import flixel.rpg.entity.Entity;

/**
 * This is the core AI class. Extend this to create real functional AI's
 * AI's are added through the AIController, which can be found in the Entity class as "ai"
 * @author Kevin
 */
class AI
{
	/**
	 * The parent entity
	 */
	public var entity:Entity;

	/**
	 * Constuctor
	 */
	public function new() 
	{
		
	}
	
	/**
	 * Update function to be called by AIController
	 */
	public function update():Void
	{
		
	}
	
	/**
	 * Properly destroy this object
	 */
	public function destroy():Void
	{
		entity = null;
	}
	
}