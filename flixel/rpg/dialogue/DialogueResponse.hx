package flixel.rpg.dialogue;
import flixel.rpg.requirement.IRequirement;

/**
 * ...
 * @author Kevin
 */
class DialogueResponse
{
	public var text:String;
	public var requirements:Array<IRequirement>;
	public var script:String;

	public function new(text:String, script:String, ?requirements:Array<IRequirement>) 
	{
		this.text = text;
		this.script = script;
		this.requirements = requirements;
	}
	
}