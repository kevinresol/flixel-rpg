package flixel.rpg.dialog;
import flixel.rpg.core.RpgScript;
import hscript.Expr;

/**
 * A response to a dialog
 * @author Kevin
 */
class DialogResponse
{
	public var text:String;
	public var requirement:Expr;
	public var action:Expr;

	public function new(text:String, actionScript:String, ?requirementScript:String = "") 
	{
		this.text = text;
		this.action = RpgScript.parseString(actionScript);
		
		if(requirementScript != "")
			this.requirement = RpgScript.parseString(requirementScript);
	}
}