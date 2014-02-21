package flixel.rpg.dialogue;
import flixel.rpg.requirement.IRequirement;
import flixel.rpg.requirement.IRequirementFactory;
import flixel.rpg.requirement.RequirementFactory;
import haxe.Json;

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
		
		dialogueActions = Type.createInstance(dialogueActionsClass, []);
		dialogueActions.system = this;
		
		load(data);
	}
	
	/**
	 * Create dialogue objects from a data string (json)
	 * @param	data
	 */
	private function load(data:String):Void
	{
		dialogues = new Map<String, Dialogue>();
		
		var data:Array<DialogueData> = Json.parse(data);
		for (dialogueData in data)
		{
			//create the dialogue object
			var dialogue = new Dialogue(dialogueData.id, dialogueData.name, dialogueData.text);			
			dialogues.set(dialogue.id, dialogue);
			
			//create the responses objects
			for (responseData in dialogueData.responses)
			{
				//map the function object
				var action = Reflect.field(dialogueActions, responseData.action);
				
				//create array of requirements
				var requirements:Array<IRequirement> = [];
				for (requirementData in responseData.requirements)
				{					
					//create and push the requirement object
					var requirement = requirementFactory.create(requirementData);
					requirements.push(requirement);
				}
				
				//create and push the response object
				dialogue.responses.push(new DialogueResponse(responseData.text, action, responseData.actionParams, requirements));
			}
		}
	}
	
	/**
	 * Set current dialogue to the specified id
	 * @param	id
	 */
	public function display(id:String):Void
	{
		setCurrent(dialogues.get(id));
			
	}
	
	/**
	 * Set current dialogue to null
	 */
	public function end():Void
	{
		setCurrent(null);
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
		}
	}
	
	
}


typedef DialogueData = 
{
	id:String,
	name:String,
	text:String,
	responses:Array<ResponseData>
	
}

typedef ResponseData =
{
	text:String, 
	action:String, 
	actionParams:Array<Dynamic>,
	requirements:Array<RequirementData>
}
