package flixel.rpg.ai;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;




/**
 * Interface for AI
 */

interface IAI
{
	public var entity:Entity;
	public function update():Void;
	public function destroy():Void;
}


/**
 * This is the core AI class. Extend this to create real functional AI's
 * AI's are added through the AIController, which can be found in the Entity class as "ai"
 * @author Kevin
 */ 
class AI implements IAI
{
	/**
	 * The parent entity
	 */
	public var entity:Entity;
	
	public var rpg(get, never):RpgEngine;

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
	
	private inline function get_rpg():RpgEngine return entity.rpg;
	
}