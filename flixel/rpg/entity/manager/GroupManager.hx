package flixel.rpg.entity.manager;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.rpg.entity.Entity;
import flixel.rpg.level.Level;

/**
 * ...
 * @author Kevin
 */
class GroupManager
{
	public static var groups:FlxGroup;
	
	public static var characters:FlxGroup;	
	public static var allies:FlxGroup;
	public static var enemies:FlxGroup;	
	
	public static var allyHitBoxes:FlxGroup;
	public static var enemyHitBoxes:FlxGroup;
	
	public static var bullets:FlxGroup;
	public static var allyBullets:FlxGroup;		
	public static var enemyBullets:FlxGroup;		
	
	public static var objects:FlxGroup;		
	
	public static var pickups:PickupManager;
	public static var playerPickupBoxes:FlxGroup;
	
	public static var player:Entity;
	
	public static var level:Level;
	
	public static function init(state:FlxState):Void
	{		
		groups = new FlxGroup();
		
		groups.add(characters = new FlxGroup());
		characters.add(allies = new FlxGroup());
		characters.add(enemies = new FlxGroup());
		
		groups.add(allyHitBoxes = new FlxGroup());
		groups.add(enemyHitBoxes = new FlxGroup());
		
		
		groups.add(bullets = new FlxGroup());
		bullets.add(allyBullets = new FlxGroup());
		bullets.add(enemyBullets = new FlxGroup());
		
		groups.add(objects = new FlxGroup());
		
		groups.add(pickups = new PickupManager());	
		groups.add(playerPickupBoxes = new FlxGroup());	
		
		
		state.add(groups);		
	}
	
	public static function registerLevel(level:Level):Void
	{
		GroupManager.level = level;
		groups.add(level);
	}
	
	public static function registerPlayer(entity:Entity):Void
	{
		registerAlly(entity);
		GroupManager.player = entity;
		GroupManager.playerPickupBoxes.add(entity.pickupBox);
	}
	
	public static function registerEnemy(entity:Entity):Void
	{		
		GroupManager.enemies.add(entity);
		GroupManager.enemyHitBoxes.add(entity.hitBox);
		GroupManager.enemyBullets.add(entity.weapon.group);
	}
	
	public static function registerAlly(entity:Entity):Void
	{		
		GroupManager.allies.add(entity);
		GroupManager.allyHitBoxes.add(entity.hitBox);
		GroupManager.allyBullets.add(entity.weapon.group);
	}
	
}