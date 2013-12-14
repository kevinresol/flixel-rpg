package flixel.rpg.entity.manager;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.rpg.entity.Entity;
import flixel.rpg.level.Level;

/**
 * ...
 * @author Kevin
 */
class GroupManager extends FlxGroup
{
	public var characters:FlxGroup;	
	public var allies:FlxGroup;
	public var enemies:FlxGroup;	
	
	public var allyHitBoxes:FlxGroup;
	public var enemyHitBoxes:FlxGroup;
	
	public var bullets:FlxGroup;
	public var allyBullets:FlxGroup;		
	public var enemyBullets:FlxGroup;		
	
	public var objects:FlxGroup;		
	
	public var pickups:PickupManager;
	public var playerPickupBoxes:FlxGroup;
	
	public var player:Entity;
	
	public var level:Level;
	
	public function new():Void
	{		
		super();
		add(characters = new FlxGroup());
		characters.add(allies = new FlxGroup());
		characters.add(enemies = new FlxGroup());
		
		add(allyHitBoxes = new FlxGroup());
		add(enemyHitBoxes = new FlxGroup());
		
		
		add(bullets = new FlxGroup());
		bullets.add(allyBullets = new FlxGroup());
		bullets.add(enemyBullets = new FlxGroup());
		
		add(objects = new FlxGroup());
		
		add(pickups = new PickupManager());	
		add(playerPickupBoxes = new FlxGroup());		
				
	}
	
	public function registerLevel(level:Level):Void
	{
		this.level = level;
		add(level);
	}
	
	public function registerPlayer(entity:Entity):Void
	{
		registerAlly(entity);
		player = entity;
		playerPickupBoxes.add(entity.pickupBox);
	}
	
	public function registerEnemy(entity:Entity):Void
	{		
		enemies.add(entity);
		enemyHitBoxes.add(entity.hitBox);
		enemyBullets.add(entity.weapon.group);
	}
	
	public function registerAlly(entity:Entity):Void
	{		
		allies.add(entity);
		allyHitBoxes.add(entity.hitBox);
		allyBullets.add(entity.weapon.group);
	}
	
}