package flixel.rpg.core;
import flixel.addons.plugin.FlxMouseControl;
import flixel.FlxG;
import flixel.FlxState;
import flixel.rpg.damage.BulletCallbacks;
import flixel.rpg.data.Data;
import flixel.rpg.dialogue.DialogueActions;
import flixel.rpg.dialogue.DialogueSystem;
import flixel.rpg.display.DamageText;
import flixel.rpg.entity.Pickup;
import flixel.rpg.level.LevelManager;
import flixel.rpg.weapon.Bullet;

/**
 * ...
 * @author Kevin
 */
class RpgEngine
{
	public static var groups(default, null):GroupManager;
	public static var factory(default, null):Factory;
	public static var data(default, null):Data;
	public static var levels(default, null):LevelManager;
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
		state.add(groups = new GroupManager());
		DamageText.init(state);	
		factory = new Factory();
		data = new Data();
		levels = new LevelManager();
		
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
		collide(groups.characters, groups.level.obstacles);
		
		//Don't walk into objects
		collide(groups.characters, groups.objects);
		
		//Don't shoot through walls
		collide(groups.bullets, groups.level.obstacles, bulletCollideWall);
		
		//Bullets should hit the target!
		overlap(groups.allyBullets, groups.enemyHitBoxes, BulletCallbacks.collideCallback, returnTrue);		
		overlap(groups.enemyBullets, groups.allyHitBoxes, BulletCallbacks.collideCallback, returnTrue);
		
		//Pickup magnet
		overlap(groups.playerPickupBoxes, groups.pickups, Pickup.moveTowardsPlayer, returnTrue);		
		
		//Take Pickups
		overlap(groups.player, groups.pickups, Pickup.picked , returnTrue);
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