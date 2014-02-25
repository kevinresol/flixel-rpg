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
	
	private var initialDialogue:Dialogue;

	public var autoRespondFirstDialogue:Bool = true;
	
	public function new() 
	{
		initialDialogue = RpgEngine.dialogue.getDialogue("door_entry_point");
	}
	
	public function start():Void
	{
		// Let the system know that this dialogue is started by a initializer
		RpgEngine.dialogue.initializer = this;
		RpgEngine.dialogue.display(initialDialogue.id);
		
		if(autoRespondFirstDialogue)
			initialDialogue.respond(initialDialogue.availableResponses[0]);		
	}
	
}