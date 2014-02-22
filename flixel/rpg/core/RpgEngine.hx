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
		//Don't walk into walls
		FlxG.collide(groups.characters, groups.level.blocks);
		
		//Don't shoot through walls
		FlxG.collide(groups.bullets, groups.level.blocks, bulletCollideWall);
		
		//Bullets should hit the target!
		FlxG.overlap(groups.allyBullets, groups.enemyHitBoxes, BulletCallbacks.collideCallback, returnTrue);		
		FlxG.overlap(groups.enemyBullets, groups.allyHitBoxes, BulletCallbacks.collideCallback, returnTrue);
		
		//Pickup magnet
		FlxG.overlap(groups.playerPickupBoxes, groups.pickups, Pickup.moveTowardsPlayer, returnTrue);		
		
		//Take Pickups
		FlxG.overlap(groups.player, groups.pickups, Pickup.picked , returnTrue);
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