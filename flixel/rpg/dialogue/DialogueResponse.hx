package flixel.rpg.dialogue;
import flixel.rpg.requirement.IRequirement;

/**
 * ...
 * @author Kevin
 */
class DialogueResponse
{
	public var text:String;
	public var action:Dynamic;
	public var actionParams:Array<Dynamic>;
	public var requirements:Array<IRequirement>;

	public function new(text:String, action:Dynamic, actionParams:Array<Dynamic>, ?requirements:Array<IRequirement>) 
	{
		this.text = text;
		this.action = action;
		this.actionParams = actionParams;
		this.requirements = requirements;
	}
	
}