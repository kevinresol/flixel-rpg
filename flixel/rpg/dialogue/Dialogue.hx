package flixel.rpg.dialogue;

/**
 * ...
 * @author Kevin
 */
class Dialogue
{
	public var id:Int;
	public var name:String;
	public var text:String;	
	public var responses:Array<DialogueResponse>;
	
	public function new(id:Int, name:String, text:String) 
	{
		this.id = id;
		this.name = name;
		this.text = text;
		this.responses = [];
	}
	
	public function respond(index:Int):Void
	{
		var response = responses[index];
		Reflect.callMethod(null, response.action, response.actionParams);
	}
	
	public function toString():String
	{
		return text;
	}
	
}

