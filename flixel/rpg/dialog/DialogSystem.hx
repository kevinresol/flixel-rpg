package flixel.rpg.dialog;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.core.RpgScript;
import flixel.rpg.data.Data;
import flixel.util.FlxSignal;
import haxe.Unserializer;

/**
 * A dialogue system. 
 * Usage: RpgEngine.dialog.display("some_dialog_id");
 * @author Kevin
 */
class DialogSystem
{
	
	/**
	 * @private
	 * A list of dialogues
	 */
	private var dialogs:Map<String, Dialog>;
	
	/**
	 * A signal to be dispatched when a dialogue changes
	 */
	public var changed:FlxSignal;
	
	/**
	 * The current dialogue
	 */
	public var current(default, null):Dialog;	
	
	/**
	 * The initialized which initialized the current dialogue. Can be null.
	 */
	public var currentInitializer:DialogInitializer;
	
	/**
	 * The scripting engine used by the dialogue system.
	 * Use script.variables.set() to set variables
	 */
	public var script(default, null):RpgScript;
	
	/**
	 * Constructor
	 * @param	data	json data
	 * @param	dialogueActionsClass	the class containing all the dialogue actions. Must extend DialogueActions. Default is DialogueActions
	 * @param	?requirementFactory if omitted, the default RequirementFactory will be used
	 */
	public function new() 
	{
		changed = new FlxSignal();
		
		script = new RpgScript();
		
		init();
	}
	
	private function init():Void
	{
		dialogs = new Map<String, Dialog>();
		for (dialogData in RpgEngine.data.dialog)
		{
			//create the dialogue object
			var dialog = new Dialog(this, dialogData.id, dialogData.name, dialogData.texts, dialogData.autoRespond);			
			dialogs.set(dialog.id, dialog);
			
			//create the responses objects
			for (responseData in dialogData.responses)
			{		
				//create and push the response object
				dialog.responses.push(new DialogResponse(responseData.text, responseData.action, responseData.requirement));
			}
		}
	}
	
	/**
	 * Set current dialogue to the specified id
	 * @param	id
	 */
	public function display(id:String):Void
	{
		if (currentInitializer != null && !script.variables.exists("entity"))
			script.variables.set("entity", currentInitializer.entity);
			
		setCurrent(dialogs.get(id));
	}
	
	public function showNext():Void
	{
		if (current.hasNext())
		{
			current.showNext(); //TODO check hasNext() twice?
			
			changed.dispatch();
		}
	}
	
	/**
	 * Set current dialog to null
	 */
	public function end():Void
	{
		if (current != null)
			current.currentParagraph = 0;// Set dialog index back to 0 (first paragraph)
		
		setCurrent(null);
		currentInitializer = null;
		script.variables.remove("entity");
	}
	
	/**
	 * @private
	 * Internal function to set the current dialogue, will dispatch the changed signal if there is a change
	 * @param	dialogue
	 */
	private inline function setCurrent(dialog:Dialog):Void
	{		
		if (current != dialog)
		{			
			current = dialog;
			
			changed.dispatch();
			
			if (dialog != null && dialog.autoRespond)
				dialog.respond(dialog.availableResponses[0]);
		}
	}
	
	/**
	 * Get a dialogue instance by id
	 * @param	id
	 * @return
	 */
	public function getDialog(id:String):Dialog
	{
		var d = dialogs.get(id);
		
		if (d == null)
			throw 'No dialog is found for id:$id';
			
		return d;
	}
	
}


