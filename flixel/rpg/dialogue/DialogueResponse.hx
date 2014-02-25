package flixel.rpg.dialogue;
import flixel.rpg.requirement.IRequirement;

/**
 * ...
 * @author Kevin
 */
class DialogueResponse
{
	public var text:String;
	public var requirementScripts:Array<String>;
	public var script:String;

	public function new(text:String, script:String, ?requirementScripts:Array<String>) 
	{
		this.text = text;
		this.script = script;
		this.requirementScripts = requirementScripts;
	}
	
	
}