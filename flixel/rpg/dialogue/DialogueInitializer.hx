package flixel.rpg.dialogue;
import flixel.rpg.core.RpgEngine;

/**
 * A component of Entity, to initialize a dialogue when 
 * a player interacts with the Entity (or by any means)
 * @author Kevin
 */
class DialogueInitializer
{
	private var initialDialogue:Dialogue;

	public var autoRespondFirstDialogue:Bool = true;
	
	public function new() 
	{
		initialDialogue = RpgEngine.dialogue.getDialogue("door_initial");
	}
	
	public function start():Void
	{
		
		RpgEngine.dialogue.display(initialDialogue.id);
		
		if(autoRespondFirstDialogue)
			initialDialogue.respond(initialDialogue.availableResponses[0]);		
	}
	
}