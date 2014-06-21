package flixel.rpg.level;

import flixel.group.FlxGroup;
import flixel.rpg.entity.Entity;
import flixel.rpg.entity.Pickup;
import flixel.tile.FlxTilemap;
import openfl.Assets;

/**
 * A Level is a FlxGroup that holds all the tilemap and entities
 * @author Kevin
 */
class Level extends FlxGroup
{
	public var background:FlxTilemap;	
	public var obstacles(default, null):FlxTilemap;
	public var overlay:FlxGroup;
	
	/**
	 * Contains only character groups (allies, enemies & neutrals)
	 * Actual entities are contained in allies, enemies & neutrals.
	 * This whole group is collided against walls
	 */
	public var characters:FlxGroup;
	
	/**
	 * Contain ally entities. Not particularly useful at the moment
	 * Contained by characters.
	 */
	public var allies:FlxGroup;
	
	/**
	 * Contain enemy entities. Not particularly useful at the moment
	 * Contained by characters.
	 */
	public var enemies:FlxGroup;
	
	/**
	 * Contain neutral entities. Not particularly useful at the moment
	 * Contained by characters.
	 */	
	public var neutrals:FlxGroup;
	
	/**
	 * The player entity. Set by registerPlayer()
	 * @see flixel.rpg.entity.manager.GroupManager.registerPlayer
	 */	
	public var player(default, null):Entity;
	
	
	/**
	 * A group containing the hitboxes of allies. Used to collide against enemyBullets.
	 */
	public var allyHitBoxes:FlxGroup;
	
	/**
	 * A group containing the hitboxes of enemies. Used to collide against allyBullets.
	 */
	public var enemyHitBoxes:FlxGroup;
	
	/**
	 * A group containing all bullets. Used to collide against walls
	 * Contains allyBulets and enemyBullets
	 */
	public var bullets:FlxGroup;
	
	/**
	 * A group containing all ally bullets. Used to collide against enemyHitBoxes.
	 */
	public var allyBullets:FlxGroup;
	
	/**
	 * A group containing all enemy bullets. Used to collide against allyHitBoxes.
	 */		
	public var enemyBullets:FlxGroup;		
	
	
	/**
	 * A group containing map objects (Not implemented yet)
	 */
	public var objects:FlxGroup;		
	
	/**
	 * A group containing pickups. Used to collide agains playerPickupBoxes
	 */
	public var pickups:FlxTypedGroup<Pickup>;
	
	/**
	 * A group containing the pickupBoxes of all players (well, currently the engine only supports one player)
	 */
	public var playerPickupBoxes:FlxGroup;
	
	/**
	 * Constructor
	 */
	public function new()
	{
		//TODO layers: background, entities, foreground
		
		super();
		
		//add(background = new FlxTilemap());
		add(obstacles = new FlxTilemap());		
		
		add(characters = new FlxGroup());
		characters.add(allies = new FlxGroup());
		characters.add(enemies = new FlxGroup());
		characters.add(neutrals = new FlxGroup());
		
		add(allyHitBoxes = new FlxGroup());
		add(enemyHitBoxes = new FlxGroup());		
		
		add(bullets = new FlxGroup());
		bullets.add(allyBullets = new FlxGroup());
		bullets.add(enemyBullets = new FlxGroup());
		
		add(objects = new FlxGroup());
		
		add(pickups = new FlxTypedGroup<Pickup>());	
		add(playerPickupBoxes = new FlxGroup());
		
		
		add(overlay = new FlxGroup());
		
	}
	
	//TODO allow more players?
	/**
	 * Register a player. Currently only one player is allowed
	 * @param	entity
	 */
	public function registerPlayer(entity:Entity):Void
	{
		//only allow registering one player
		if (player != null) 
			throw "Already registered a player";
		
		registerAlly(entity);
		playerPickupBoxes.add(entity.pickupBox);
		player = entity;
	}
	
	public function unregisterPlayer():Void
	{		
		if (player == null) 
			throw "Player is null";			
		
		unregisterAlly(player);
		playerPickupBoxes.remove(player.pickupBox);
		player = null;
	}
	
	/**
	 * Register an entity as enemy.
	 * @param	entity
	 */
	public function registerEnemy(entity:Entity):Void
	{		
		enemies.add(entity);
		enemyHitBoxes.add(entity.hitBox);
		enemyBullets.add(entity.weapon.group);
	}
	
	/**
	 * Register an entity as ally.
	 * @param	entity
	 */
	public function registerAlly(entity:Entity):Void
	{		
		allies.add(entity);
		allyHitBoxes.add(entity.hitBox);
		allyBullets.add(entity.weapon.group);
	}
	
	public function unregisterAlly(entity:Entity):Void
	{		
		allies.remove(entity);
		allyHitBoxes.remove(entity.hitBox);
		allyBullets.remove(entity.weapon.group);
	}
	
	/**
	 * Register an entity as neutral.
	 * @param	entity
	 */
	public function registerNeutral(entity:Entity):Void
	{		
		neutrals.add(entity);
	}
}