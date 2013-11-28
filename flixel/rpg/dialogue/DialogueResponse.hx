package flixel.rpg.dialogue;

/**
 * ...
 * @author Kevin
 */
class DialogueResponse
{
	public var text:String;
	public var action:Dynamic;
	public var actionParams:Array<Dynamic>;

	public function new(text:String, action:Dynamic, actionParams:Array<Dynamic>) 
	{
		this.text = text;
		this.action = action;
		this.actionParams = actionParams;
	}
	
}