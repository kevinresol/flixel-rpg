package flixel.rpg.dialogue;

/**
 * ...
 * @author Kevin
 */
class DialogueActions
{

	public var system:DialogueSystem;
	
	public function new()
	{
		
	}
	
	public function displayDialogue(id:Int):Void
	{
		system.display(id);
	}
	
	public function endDialogue():Void
	{
		system.end();
	}
	
}