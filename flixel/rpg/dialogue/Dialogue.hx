package flixel.rpg.dialogue;
using flixel.util.FlxArrayUtil;
/**
 * ...
 * @author Kevin
 */
class Dialogue
{
	/**
	 * ID is good
	 */
	public var id:String;
	
	/**
	 * Name (of the speaker?)
	 */
	public var name:String;
	
	/**
	 * The actual dialogue contents
	 */
	public var text:String;	
	
	/**
	 * Array of all responses associated with this dialogue
	 */
	public var responses:Array<DialogueResponse>;
	
	/**
	 * Array of available responses. i.e. the requirements are fulfilled
	 */
	public var availableResponses(get, null):Array<DialogueResponse>;
	
	public var autoRespond:Bool = false;
	
	private var system:DialogueSystem;
	
	/**
	 * Constructor
	 * @param	id
	 * @param	name
	 * @param	text
	 */
	public function new(system:DialogueSystem, id:String, name:String, text:String, ?autoRespond:Bool) 
	{
		this.system = system;
		this.id = id;
		this.name = name;
		this.text = text;
		this.responses = [];
		this.autoRespond = autoRespond;
	}
	
	/**
	 * Respond to this dialogue
	 * @param	response	A DialogueResponse object. Must belong to this dialogue object.
	 */
	public function respond(response:DialogueResponse):Void
	{		
		if (responses.indexOf(response) == -1)
			throw "The specified response object does not belongs to this dialogue object";
		
		system.script.execute(response.script);
		//Reflect.callMethod(null, response.action, response.actionParams);
	}
	
	/**
	 * Debug string
	 * @return
	 */
	public function toString():String
	{
		return text;
	}
	
	
	private function get_availableResponses():Array<DialogueResponse>
	{
		var result = [];
		
		for (response in responses)
		{
			var fulfilled:Bool = true;
			
			// Check if all requirements fulfilled
			if (response.requirementScripts != null)
			{
				for (requirementScript in response.requirementScripts)
				{
					// Create the IRequirement instance from script
					var requirement = system.script.execute(requirementScript);
					
					if (!requirement.fulfilled())
					{
						fulfilled = false;
						break;
					}
				}
			}
			
			if (fulfilled)
				result.push(response);
		}
		
		return result;
	}
}

