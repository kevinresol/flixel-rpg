package flixel.rpg.core;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.rpg.entity.Entity;
import flixel.rpg.entity.Pickup;
import flixel.rpg.level.Level;
import flixel.util.FlxSort;

/**
 * A manager to manage various groups. These groups are then used by RpgEngine to handle collisions
 * @author Kevin
 */
class GroupManager extends FlxGroup
{
	
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
	 * Current level
	 */
	public var level:Level;
	
	/**
	 * Constructor
	 */
	public function new():Void
	{		
		super();
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
		
	}
	
	/**
	 * Register a level
	 * @param	level
	 */
	@:allow(flixel.rpg.level.LevelManager)
	private function registerLevel(level:Level):Void
	{
		if (this.level != null)
			remove(this.level);
			
		this.level = level;
		add(level);
		
		sort(
				function(order:Int, o1:FlxBasic, o2:FlxBasic)
					return FlxSort.byValues(order, o1 == level ? 1 : 0, o2 == level ? 1 : 0),
				FlxSort.DESCENDING
			);
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
		player = entity;
		playerPickupBoxes.add(entity.pickupBox);
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
	
	/**
	 * Register an entity as neutral.
	 * @param	entity
	 */
	public function registerNeutral(entity:Entity):Void
	{		
		neutrals.add(entity);
	}
	
}