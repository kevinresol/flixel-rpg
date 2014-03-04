package flixel.rpg.dialog;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;

/**
 * A component of Entity, to initialize a dialogue when 
 * a player interacts with the Entity (or by any means)
 * @author Kevin
 */
class DialogInitializer
{
	public var entity:Entity;
	
	public var dialogueId:String;
	
	public function new() 
	{
		
	}
	
	public function start():Void
	{
		// Let the system know that this dialogue is started by a initializer
		RpgEngine.dialog.currentInitializer = this;
		RpgEngine.dialog.display(dialogueId);			
	}
	
}