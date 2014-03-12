package flixel.rpg.dialog;
import flixel.rpg.requirement.IRequirement;

/**
 * A response to a dialog
 * @author Kevin
 */
class DialogResponse
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