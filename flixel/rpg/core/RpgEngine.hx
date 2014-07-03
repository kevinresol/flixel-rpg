package flixel.rpg.core;
import flixel.FlxG;
import flixel.FlxState;
import flixel.rpg.data.Data;
import flixel.rpg.dialog.DialogSystem;
import flixel.rpg.entity.Entity;
import flixel.rpg.entity.EntityManager;
import flixel.rpg.entity.Pickup;
import flixel.rpg.event.EventManager;
import flixel.rpg.level.Level;
import flixel.rpg.weapon.Bullet;
import flixel.rpg.weapon.BulletCallbacks;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;

/**
 * The core of the RPG framework.
 * @author Kevin
 */
class RpgEngine implements IFlxDestroyable
{
	public static var current(default, null):RpgEngine;
	
	public var levels(default, null):LevelManager;
	public var data(default, null):Data;
	public var scripting(default, null):RpgScripting;
	public var entities(default, null):EntityManager;
	public var events(default, null):EventManager;
	
	public var state(default, set):FlxState;
	
	// Shorthand propertes (mainly for scripting)
	public var level(get, never):Level;
	public var player(get, never):Entity;
	
	
	
	/**
	 * The DialogueSystem object. Call enableDialogue() before accessing this object
	 */
	public var dialog:DialogSystem;
	
	/**
	 * Initialize the engine on a FlxState
	 * @param	state
	 */
	public function new(setAsCurrent:Bool = true):Void
	{
		if(setAsCurrent)
			current = this;
		
		levels = new LevelManager(this);
		entities = new EntityManager(this);
		data = new Data();
		scripting = RpgScripting.get(this);
		events = new EventManager(this);
	}
	
	public function enableDialog():Void
	{
		if (data.dialog == null) 
			throw "Dialog data does not exist";
			
		dialog = new DialogSystem(this);
	}
	
	public function destroy():Void
	{
		state = null;
		levels.destroy();
		scripting.destroy();
	}

	/**
	 * The main collide function.
	 * A collection of collide checks performed on various groups of objects
	 */
	public function collide():Void
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
	
	private function bulletCollideWall(bullet:Bullet, map):Void
	{
		bullet.kill();
	}
	
	
	private function returnTrue(?p1, ?p2):Bool
	{
		return true;
	}
	
	private function set_state(v:FlxState):FlxState return levels.state = v;
	private function get_level():Level return levels.current;
	private function get_player():Entity return levels.current.player;
	
	
}