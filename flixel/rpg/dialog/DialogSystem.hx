package flixel.rpg.dialog;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.core.RpgScripting;
import flixel.util.FlxSignal;

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
	
	private var rpg:RpgEngine;
	
	public var scripting(get, never):RpgScripting;
	
	/**
	 * Constructor
	 * @param	data	json data
	 * @param	dialogueActionsClass	the class containing all the dialogue actions. Must extend DialogueActions. Default is DialogueActions
	 * @param	?requirementFactory if omitted, the default RequirementFactory will be used
	 */
	public function new(rpg:RpgEngine) 
	{
		changed = new FlxSignal();
		
		this.rpg = rpg;
		
		init();
	}
	
	private function init():Void
	{
		dialogs = new Map();
		for (dialogData in RpgEngine.current.data.dialog)
		{
			//create the dialogue object
			var dialog = new Dialog(this, dialogData.id, dialogData.name, dialogData.texts, dialogData.autoRespond);			
			dialogs.set(dialog.id, dialog);
			
			//create the responses objects
			for (responseData in dialogData.responses)
			{		
				//create and push the response object
				dialog.responses.push(new DialogResponse(responseData.text, responseData.dialog, responseData.requirement, responseData.events));
			}
		}
	}
	
	/**
	 * Set current dialogue to the specified id
	 * @param	id
	 */
	public inline function display(id:String):Void
	{
		setCurrent(getDialog(id));
	}
	
	/**
	 * Show next piece of text
	 * @return true if there is next, false if there is no next
	 */
	public function showNext():Bool
	{
		if (current != null && current.hasNext)
		{
			current.currentParagraph++;
			changed.dispatch();
			return true;
		}
		else
			return false;
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
	}
	
	/**
	 * Respond to current dialog
	 * @param	response	A DialogResponse object. Must belong to the current dialog object.
	 */
	public function respond(response:DialogResponse):Void
	{
		if (current == null)
			throw "No active dialog";
			
		if (current.responses.indexOf(response) == -1)
			throw "The specified response object does not belongs to this dialogue object";
		
		if (response.dialog != null)
			display(response.dialog);
		
		for (event in response.events)
			rpg.events.dispatch(event);
	}
	
	/**
	 * Get a dialogue instance by id
	 * @param	id
	 * @return
	 */
	public inline function getDialog(id:String):Dialog
	{
		var d = dialogs.get(id);
		
		if (d == null)
			throw 'No dialog is found for id:$id';
			
		return d;
	}
	
	@:allow(flixel.rpg.dialog.Dialog)
	private inline function setVariable():Void
	{
		if (currentInitializer != null)
			rpg.scripting.variables.set("entity", currentInitializer.entity);
	}
	
	@:allow(flixel.rpg.dialog.Dialog)
	private inline function removeVariable():Void 
	{
		if (currentInitializer != null)
			rpg.scripting.variables.remove("entity");
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
			
			if (current != null)
			{
				if(current.autoRespond)
					respond(dialog.availableResponses[0]);
			}
		}
	}
	
	
	private inline function get_scripting():RpgScripting
	{
		return rpg.scripting;
	}
	
}


