package flixel.rpg.dialog;
import flixel.rpg.core.RpgScripting;
import hscript.Expr;

/**
 * A response to a dialog
 * @author Kevin
 */
class DialogResponse
{
	public var text:String;
	public var requirement:Expr;
	public var dialog:Null<String>;
	public var events:Array<String>;

	public function new(text:String, ?dialog:Null<String>, ?requirementScript:String = "", ?events:Array<String>) 
	{
		this.text = text;
		this.dialog = dialog;
		this.events = events == null ? [] : events;
		
		if(requirementScript != "")
			this.requirement = RpgScripting.parseString(requirementScript);
	}
}