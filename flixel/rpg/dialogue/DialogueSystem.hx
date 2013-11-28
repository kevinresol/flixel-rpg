package flixel.rpg.dialogue;
import haxe.Json;

/**
 * ...
 * @author Kevin
 */
class DialogueSystem
{
	private var dialogueActions:DialogueActions;
	private var dialogues:Array<Dialogue>;
	
	public var onChange:Void->Void;
	public var current(default, null):Dialogue;
	
	public function new(data:String, dialogueActionsClass:Class<DialogueActions>, ?onChange:Void->Void) 
	{
		this.onChange = onChange;
		
		dialogueActions = Type.createInstance(dialogueActionsClass, []);
		dialogueActions.system = this;
		
		load(data);
	}
	
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
			for (r in dialogueData.responses)
			{
				var action = Reflect.field(dialogueActions, r.action);
				dialogue.responses.push(new DialogueResponse(r.text, action, r.actionParams));
			}
		}
	}
	
	public function display(id:Int):Void
	{
		setCurrent(get(id));
			
	}
	
	public function end():Void
	{
		setCurrent(null);
	}
	
	private inline function setCurrent(dialogue:Dialogue):Void
	{		
		if (current == dialogue)
			return;
			
		current = dialogue;
		
		if (onChange != null)
			onChange();	
	}
	
	private function get(id:Int):Dialogue
	{
		for (d in dialogues)
		{
			if (d.id == id)
				return d;
		}
		return null;
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
	actionParams:Array<Dynamic>
}