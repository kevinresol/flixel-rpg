package flixel.rpg.dialog;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.core.RpgScript;
import flixel.rpg.requirement.IRequirement;
import flixel.rpg.requirement.IRequirementFactory;
import flixel.rpg.requirement.RequirementFactory;
import haxe.Unserializer;

/**
 * A dialogue system. Usage: create instance then call display()
 * @author Kevin
 */
class DialogSystem
{
	/**
	 * @private
	 * A reference to the DialogueAction object
	 */
	private var dialogActions:DialogActions;
	
	/**
	 * @private
	 * A list of dialogues
	 */
	private var dialogs:Map<String, Dialog>;
	
	/**
	 * A callback to be called when a dialogue changes
	 */
	public var onChange:Void->Void;
	
	/**
	 * The current dialogue
	 */
	public var current(default, null):Dialog;
	
	/**
	 * A requirement factory
	 */
	public var requirementFactory:IRequirementFactory;
	
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
	 * @param	?onChange	callback on dialogue change
	 * @param	?requirementFactory if omitted, the default RequirementFactory will be used
	 */
	public function new(data:String, ?dialogActionsClass:Class<DialogActions>, ?onChange:Void->Void, ?requirementFactory:IRequirementFactory) 
	{
		
		this.onChange = onChange;
		
		this.requirementFactory = (requirementFactory == null ? new RequirementFactory() : requirementFactory);
		
		if (dialogActionsClass == null)
			dialogActionsClass = DialogActions;
		
		// Create the DialogueAction object
		dialogActions = Type.createInstance(dialogActionsClass, []);
		dialogActions.system = this;
		
		// Create the scripting engine and allow the DialogueAction object
		// to be accessed as "action"
		script = new RpgScript();
		script.variables.set("action", dialogActions);
		script.variables.set("requirementFactory", this.requirementFactory);
		script.variables.set("RpgEngine", RpgEngine);
		
		load(data);
	}
	
	/**
	 * Create dialogue objects from a data string (haxe-serialized)
	 * @param	data
	 */
	private function load(data:String):Void
	{
		dialogs = new Map<String, Dialog>();
		var data:Array<DialogData> = Unserializer.run(data);
		for (dialogData in data)
		{
			//create the dialogue object
			var dialog = new Dialog(this, dialogData.id, dialogData.name, dialogData.text, dialogData.autoRespond);			
			dialogs.set(dialog.id, dialog);
			
			//create the responses objects
			for (responseData in dialogData.responses)
			{		
				//create and push the response object
				dialog.responses.push(new DialogResponse(responseData.text, responseData.script, responseData.requirementScripts));
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
	
	/**
	 * Set current dialogue to null
	 */
	public function end():Void
	{
		setCurrent(null);
		currentInitializer = null;
		script.variables.remove("entity");
	}
	
	/**
	 * @private
	 * Internal function to set the current dialogue, will call the onChange callback if there is a change
	 * @param	dialogue
	 */
	private inline function setCurrent(dialog:Dialog):Void
	{		
		if (current != dialog)
		{			
			current = dialog;
			
			if (onChange != null)
				onChange();
			
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


typedef DialogData = 
{
	id:String,
	name:String,
	text:String,
	responses:Array<ResponseData>,
	?autoRespond:Bool
}

typedef ResponseData =
{
	text:String, 
	script:String, 
	requirementScripts:Array<String>
}
