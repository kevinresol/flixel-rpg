package flixel.rpg.dialogue;
import flixel.rpg.dialogue.DialogueSystem.RequirementData;
import flixel.rpg.requirement.IRequirement;
import flixel.rpg.requirement.ItemRequirement;
import haxe.Json;

/**
 * A dialogue system.
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
	private var dialogues:Array<Dialogue>;
	
	/**
	 * A callback to be called when a dialogue changes
	 */
	public var onChange:Void->Void;
	
	/**
	 * The current dialogue
	 */
	public var current(default, null):Dialogue;
	
	/**
	 * Constructor
	 * @param	data	json data
	 * @param	dialogueActionsClass	the class containing all the dialogue actions. Must extend DialogueActions.
	 * 									Default is DialogueActions
	 * @param	?onChange	callback on dialogue change
	 */
	public function new(data:String, ?dialogueActionsClass:Class<DialogueActions>, ?onChange:Void->Void) 
	{
		this.onChange = onChange;
		
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
		dialogues = [];
		
		var data:Array<DialogueData> = Json.parse(data);
		for (dialogueData in data)
		{
			//create the dialogue object
			var dialogue = new Dialogue(dialogueData.id, dialogueData.name, dialogueData.text);			
			dialogues.push(dialogue);
			
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
					var requirement = createRequirement(requirementData);
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
	public function display(id:Int):Void
	{
		setCurrent(get(id));
			
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
	
	/**
	 * @private
	 * Get the dialogue object of the specified id
	 * @param	id
	 * @return
	 */
	private function get(id:Int):Dialogue
	{
		for (d in dialogues)
		{
			if (d.id == id)
				return d;
		}
		return null;
	}
	
	/**
	 * @private
	 * Internal function for creating a Requirement Object
	 * @param	data
	 * @return
	 */
	private function createRequirement(data:RequirementData):IRequirement
	{		
		switch(data.type)
		{
			case "item": 	return new ItemRequirement(data.id, data.count);
			default: 		throw "Requriement type not supported";				
		}
		
	}
}


typedef DialogueData = 
{
	id:Int,
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

typedef RequirementData = 
{
	type:String,
	?id:Int,
	?count:Int
}