package flixel.rpg.dialogue;

/**
 * A set of functions meant to be used by dialogue responses.
 * This class only provide some basic/common response actions.
 * Can be extended but not meant to be instantialized by user.
 * Pass the class to DialogueSystem's contructor
 * @author Kevin
 */
class DialogueActions
{
	/**
	 * A reference to the dialogue system. (To call its methods)
	 */
	public var system:DialogueSystem;
	
	/**
	 * Contructor.
	 */
	public function new()
	{
		
	}
	
	/**
	 * Display a dialogue.
	 * @param	id
	 */
	public function displayDialogue(id:String):Void
	{
		system.display(id);
	}
	
	/**
	 * End the dialogue
	 */
	public function endDialogue():Void
	{
		system.end();
	}
	
}