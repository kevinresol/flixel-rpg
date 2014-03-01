package flixel.rpg.dialogue;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;

/**
 * A component of Entity, to initialize a dialogue when 
 * a player interacts with the Entity (or by any means)
 * @author Kevin
 */
class DialogueInitializer
{
	public var entity:Entity;
	
	public var dialogueId:String;
	
	public function new() 
	{
		
	}
	
	public function start():Void
	{
		// Let the system know that this dialogue is started by a initializer
		RpgEngine.dialogue.currentInitializer = this;
		RpgEngine.dialogue.display(dialogueId);			
	}
	
}