package flixel.rpg.dialog;
import flixel.rpg.core.RpgScripting;
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
	
	public var hasNext(get, never):Bool;
	
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
		
		system.setVariable();
		for (response in responses)
		{
			// Check if all requirements fulfilled
			var fulfilled = response.requirement == null || system.scripting.executeAst(response.requirement);
			
			if (fulfilled)
				result.push(response);
		}
		system.removeVariable();
		
		return result;
	}
	
	private inline function get_hasNext():Bool
	{
		return currentParagraph < texts.length - 1;
	}
	
	private inline function get_text():String
	{
		return texts[currentParagraph];
	}
}

