package flixel.rpg.core;
import flixel.FlxG;
import flixel.FlxState;
import flixel.rpg.damage.BulletCallbacks;
import flixel.rpg.data.Data;
import flixel.rpg.dialogue.DialogueActions;
import flixel.rpg.dialogue.DialogueSystem;
import flixel.rpg.display.DamageText;
import flixel.rpg.entity.Pickup;
import flixel.rpg.weapon.Bullet;

/**
 * ...
 * @author Kevin
 */
class RpgEngine
{
	public static var levels(default, null):LevelManager;
	public static var data(default, null):Data;
	public static var script(default, null):RpgScript;
	
	/**
	 * The DialogueSystem object. Call enableDialogue() before accessing this object
	 */
	public static var dialogue:DialogueSystem;
	
	/**
	 * Initialize the engine on a FlxState
	 * @param	state
	 */
	public static function init(state:FlxState):Void
	{
		levels = new LevelManager(state);
		DamageText.init();	
		data = new Data();
		
		script = new RpgScript();
		script.variables.set("RpgEngine", RpgEngine);
	}
	
	public static function enableDialogue(data:String, dialogueActionsClass:Class<DialogueActions>, ?onChange:Void->Void):Void
	{
		dialogue = new DialogueSystem(data, dialogueActionsClass, onChange);
	}

	/**
	 * The main collide function.
	 * A collection of collide checks performed on various groups of objects
	 */
	public inline static function collide():Void
	{
		var collide = FlxG.collide;
		var overlap = FlxG.overlap;
		
		//Don't walk into walls
		collide(levels.current.characters, levels.current.obstacles);
		
		//Don't walk into objects
		collide(levels.current.characters, levels.current.objects);
		
		//Don't shoot through walls
		collide(levels.current.bullets, levels.current.obstacles, bulletCollideWall);
		
		//Bullets should hit the target!
		overlap(levels.current.allyBullets, levels.current.enemyHitBoxes, BulletCallbacks.collideCallback, returnTrue);		
		overlap(levels.current.enemyBullets, levels.current.allyHitBoxes, BulletCallbacks.collideCallback, returnTrue);
		
		//Pickup magnet
		overlap(levels.current.playerPickupBoxes, levels.current.pickups, Pickup.moveTowardsPlayer, returnTrue);		
		
		//Take Pickups
		overlap(levels.current.player, levels.current.pickups, Pickup.picked , returnTrue);
	}
	
	
	private inline static function bulletCollideWall(bullet:Bullet, map):Void
	{
		bullet.kill();
	}
	
	
	private inline static function returnTrue(?p1, ?p2):Bool
	{
		return true;
	}
	
	
}