package flixel.rpg.dialog;
using flixel.util.FlxArrayUtil;
/**
 * A dialog includes the dialog texts and list of responses
 * @author Kevin
 */
class Dialog
{
	/**
	 * ID is good
	 */
	public var id:String;
	
	/**
	 * Name (of the speaker?)
	 */
	public var name:String;
	
	public var text(get, never):String;
	/**
	 * The actual dialogue contents
	 */
	public var texts:Array<String>;	
	
	/**
	 * Array of all responses associated with this dialogue
	 */
	public var responses:Array<DialogResponse>;
	
	/**
	 * Array of available responses. i.e. the requirements are fulfilled
	 */
	public var availableResponses(get, null):Array<DialogResponse>;
	
	public var autoRespond:Bool = false;
	
	private var system:DialogSystem;
	
	@:allow(flixel.rpg.dialog.DialogSystem)
	private var currentParagraph:Int = 0;
	
	/**
	 * Constructor
	 * @param	id
	 * @param	name
	 * @param	text
	 */
	public function new(system:DialogSystem, id:String, name:String, texts:Array<String>, ?autoRespond:Bool) 
	{
		this.system = system;
		this.id = id;
		this.name = name;
		this.texts = texts;
		this.responses = [];
		this.autoRespond = autoRespond;
	}
	
	/**
	 * Respond to this dialogue
	 * @param	response	A DialogueResponse object. Must belong to this dialogue object.
	 */
	public function respond(response:DialogResponse):Void
	{		
		if (responses.indexOf(response) == -1)
			throw "The specified response object does not belongs to this dialogue object";
		
		system.script.executeAst(response.action);
	}
	
	/**
	 * Show next piece of text
	 * @return true if there is next, false if there is no next
	 */
	@:allow(flixel.rpg.dialog.DialogSystem)
	private function showNext():Bool
	{
		if (hasNext())
		{
			currentParagraph++;
			return true;
		}
		else
			return false;
	}
	
	public inline function hasNext():Bool
	{
		return currentParagraph < texts.length - 1;
	}
	
	/**
	 * Debug string
	 * @return
	 */
	public function toString():String
	{
		return texts[currentParagraph];
	}
	
	
	private function get_availableResponses():Array<DialogResponse>
	{
		var result = [];
		
		for (response in responses)
		{
			// Check if all requirements fulfilled
			var fulfilled = response.requirement == null || system.script.executeAst(response.requirement);
			
			if (fulfilled)
				result.push(response);
		}
		
		return result;
	}
	
	private function get_text():String
	{
		return texts[currentParagraph];
	}
}

