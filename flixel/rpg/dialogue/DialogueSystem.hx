package flixel.rpg.dialogue;
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
class DialogueSystem
{
	/**
	 * @private
	 * A reference to the DialogueAction object
	 */
	private var dialogueActions:DialogueActions;
	
	/**
	 * @private
	 * A list of dialogues
	 */
	private var dialogues:Map<String, Dialogue>;
	
	/**
	 * A callback to be called when a dialogue changes
	 */
	public var onChange:Void->Void;
	
	/**
	 * The current dialogue
	 */
	public var current(default, null):Dialogue;
	
	/**
	 * A requirement factory
	 */
	public var requirementFactory:IRequirementFactory;
	
	/**
	 * The initialized which initialized the current dialogue. Can be null.
	 */
	public var currentInitializer:DialogueInitializer;
	
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
	public function new(data:String, ?dialogueActionsClass:Class<DialogueActions>, ?onChange:Void->Void, ?requirementFactory:IRequirementFactory) 
	{
		
		this.onChange = onChange;
		
		this.requirementFactory = (requirementFactory == null ? new RequirementFactory() : requirementFactory);
		
		if (dialogueActionsClass == null)
			dialogueActionsClass = DialogueActions;
		
		// Create the DialogueAction object
		dialogueActions = Type.createInstance(dialogueActionsClass, []);
		dialogueActions.system = this;
		
		// Create the scripting engine and allow the DialogueAction object
		// to be accessed as "action"
		script = new RpgScript();
		script.variables.set("action", dialogueActions);
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
		dialogues = new Map<String, Dialogue>();
		var data:Array<DialogueData> = Unserializer.run(data);
		for (dialogueData in data)
		{
			//create the dialogue object
			var dialogue = new Dialogue(this, dialogueData.id, dialogueData.name, dialogueData.text, dialogueData.autoRespond);			
			dialogues.set(dialogue.id, dialogue);
			
			//create the responses objects
			for (responseData in dialogueData.responses)
			{		
				//create and push the response object
				dialogue.responses.push(new DialogueResponse(responseData.text, responseData.script, responseData.requirementScripts));
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
			
		setCurrent(dialogues.get(id));
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
	private inline function setCurrent(dialogue:Dialogue):Void
	{		
		if (current != dialogue)
		{			
			current = dialogue;
			
			if (onChange != null)
				onChange();
			
			if (dialogue != null && dialogue.autoRespond)
				dialogue.respond(dialogue.availableResponses[0]);
		}
	}
	
	/**
	 * Get a dialogue instance by id
	 * @param	id
	 * @return
	 */
	public function getDialogue(id:String):Dialogue
	{
		var d = dialogues.get(id);
		
		if (d == null)
			throw 'No dialogue is found for id:$id';
			
		return d;
	}
	
}


typedef DialogueData = 
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
