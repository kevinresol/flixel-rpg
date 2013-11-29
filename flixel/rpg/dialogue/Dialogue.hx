package flixel.rpg.dialogue;
using flixel.util.FlxArrayUtil;
/**
 * ...
 * @author Kevin
 */
class Dialogue
{
	public var id:Int;
	public var name:String;
	public var text:String;	
	
	/**
	 * Array of all responses associated with this dialogue
	 */
	public var responses:Array<DialogueResponse>;
	
	/**
	 * Array of available responses. i.e. the requirements are fulfilled
	 */
	public var availableResponses(get, null):Array<DialogueResponse>;
	private function get_availableResponses():Array<DialogueResponse>
	{
		var result = [];
		
		for (response in responses)
		{
			var fulfilled:Bool = true;
			
			for (requirement in response.requirements)
			{
				if (!requirement.fulfilled())
				{
					fulfilled = false;
					break;
				}
			}
			
			if (fulfilled)
				result.push(response);
		}
		
		return result;
	}
	
	/**
	 * Constructor
	 * @param	id
	 * @param	name
	 * @param	text
	 */
	public function new(id:Int, name:String, text:String) 
	{
		this.id = id;
		this.name = name;
		this.text = text;
		this.responses = [];
	}
	
	/**
	 * Respond to this dialogue
	 * @param	response	A DialogueResponse object
	 */
	public function respond(response:DialogueResponse):Void
	{		
		if (responses.indexOf(response) == -1)
			throw "The specified response object does not belongs to this dialogue object";
		
		Reflect.callMethod(null, response.action, response.actionParams);
	}
	
	/**
	 * Debug string
	 * @return
	 */
	public function toString():String
	{
		return text;
	}
	
}

