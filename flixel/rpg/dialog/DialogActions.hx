package flixel.rpg.dialog;

/**
 * A set of functions meant to be used by dialogue responses.
 * This class only provide some basic/common response actions.
 * Can be extended but not meant to be instantialized by user.
 * Pass the class to DialogueSystem's contructor
 * @author Kevin
 */
class DialogActions
{
	/**
	 * A reference to the dialogue system. (To call its methods)
	 */
	public var system:DialogSystem;
	
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
	public function displayDialog(id:String):Void
	{
		system.display(id);
	}
	
	/**
	 * End the dialogue
	 */
	public function endDialog():Void
	{
		system.end();
	}
	
}