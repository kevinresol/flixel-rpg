package flixel.rpg.state;

import flixel.FlxState;
import flixel.rpg.dialogue.DialogueActions;
import flixel.rpg.dialogue.DialogueSystem;
import flixel.rpg.display.lighting.LightingSystem;

/**
 * ...
 * @author Kevin
 */
class GameState extends FlxState
{
	/**
	 * The HUD sub-state. All UI should be added here
	 */
	public var hud:HUDSubState;
	
	/**
	 * The Lighting object. Call enableLighting() before accessing this object
	 */
	private var lighting:LightingSystem;
	
	/**
	 * The DialogueSystem object. Call enableDialogue() before accessing this object
	 */
	private var dialogueSystem:DialogueSystem;
	
	/**
	 * Contructor
	 */
	public function new() 
	{
		super();	
	}	
	
	override public function create():Void 
	{
		super.create();
		hud = new HUDSubState();
		setSubState(hud);
	}
	
	/**
	 * Enable the lighting system
	 * @param	color
	 */
	private function enableLighting(color:UInt):Void
	{
		if (lighting != null)
			return;
		
		lighting = new LightingSystem(this, color);
	}
	
	/**
	 * Enable the dialog system
	 * @param	data
	 * @param	dialogueActionsClass
	 * @param	onChange
	 */
	private function enableDialogue(data:String, dialogueActionsClass:Class<DialogueActions>, ?onChange:Void->Void):Void
	{
		dialogueSystem = new DialogueSystem(data, dialogueActionsClass, onChange);
	}
	
	/**
	 * Override.
	 * Update the lighting system if it is enabled.
	 */
	override public function update():Void 
	{
		if (lighting != null)
			lighting.update();
			
		super.update();
	}
	
	
	/**
	 * Set to true to pause the game. The HUD will still work.
	 */
	public var paused(default, set):Bool;
	private function set_paused(v:Bool):Bool
	{
		if (paused != v)
		{
			paused = v;
			persistentUpdate = !v;
		}
		return v;
	}
	
	
}