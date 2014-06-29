package flixel.rpg.core;
import flixel.FlxG;
import flixel.FlxState;
import flixel.rpg.data.Data;
import flixel.rpg.dialog.DialogSystem;
import flixel.rpg.entity.Entity;
import flixel.rpg.entity.EntityManager;
import flixel.rpg.entity.Pickup;
import flixel.rpg.level.Level;
import flixel.rpg.weapon.Bullet;
import flixel.rpg.weapon.BulletCallbacks;
import openfl.Assets;

/**
 * The core of the RPG framework.
 * @author Kevin
 */
class RpgEngine
{
	public static var levels(default, null):LevelManager;
	public static var data(default, null):Data = new Data();
	public static var scripting(default, null):RpgScript = new RpgScript();
	public static var entities(default, null):EntityManager = new EntityManager();
	
	// Shorthand propertes (mainly for scripting)
	public static var level(get, never):Level;
	public static var player(get, never):Entity;
	
	/**
	 * The DialogueSystem object. Call enableDialogue() before accessing this object
	 */
	public static var dialog:DialogSystem;
	
	/**
	 * Initialize the engine on a FlxState
	 * @param	state
	 */
	public static function init(state:FlxState):Void
	{
		levels = new LevelManager(state);
		
		data.entityData = Assets.getText("assets/data/output/entity_data.txt");
		data.dialogData = Assets.getText("assets/data/output/dialog_data.txt");
		data.weaponData = Assets.getText("assets/data/output/weapon_data.txt");
		data.tradeData = Assets.getText("assets/data/output/trade_data.txt");
		data.itemData = Assets.getText("assets/data/output/item_data.txt");
		
		scripting.variables.set("RpgEngine", RpgEngine);
	}
	
	public static function enableDialog():Void
	{
		if (data.dialog == null) 
			throw "Dialog data does not exist";
			
		dialog = new DialogSystem();
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
	
	private static function get_level():Level return levels.current;
	private static function get_player():Entity return levels.current.player;
	
}