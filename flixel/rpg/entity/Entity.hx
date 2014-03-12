package flixel.rpg.entity;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.rpg.ai.AIController;
import flixel.rpg.damage.DamageOverTime;
import flixel.rpg.damage.WeaponController;
import flixel.rpg.dialog.DialogInitializer;
import flixel.rpg.display.DamageText;
import flixel.rpg.interaction.MouseHandler;
import flixel.rpg.inventory.Inventory;
import flixel.rpg.stat.StatController;
import flixel.rpg.system.HitBox;
import flixel.rpg.trade.Trader;
import flixel.util.FlxTimer;

/**
 * A basic entity in this RPG framework.
 * Has the following built-in components which can be enabled at will:
	 * hitBox 		(for bullet collision)
	 * pickupBox 	(a range that will "attact" pickups, imagine Terraria)
	 * ai 			(plugins to define the behavior of this entity)
	 * stat 		(attributes of this entity)
	 * inventory 	(hold some items)
	 * equipments 	(a special inventory)
	 * trader 		(trade items with other entities such as NPC, chests...)
	 * DOT 			(damage over time)
	 * weapon 		(allow this entity to do some attack)
	 * dialog 		(bring up a dialog section)
	 * mouse 		(mouse interaction with this entity)
 * @author Kevin
 */
class Entity extends FlxSprite
{
	/**
	 * Hitbox for bullet collision
	 */
	public var hitBox:HitBox;
	
	/**
	 * Hitbox for pickup
	 */
	public var pickupBox:HitBox;
	
	/**
	 * Engaged target of this entity
	 */
	public var target(default, null):Entity;
	
	/**
	 * The entity that just attacked this entity
	 */
	public var lastHitBy:Entity;
	
	/**
	 * Flag to indicate if the entity is enaged
	 */
	public var engaged(get, never):Bool;
	private inline function get_engaged():Bool { return target != null;}
	
	/**
	 * AI controller
	 */
	public var ai:AIController;	
	
	/**
	 * Stat controller
	 */
	public var stat:StatController;
	
	/**
	 * Inventory
	 */
	public var inventory:Inventory;
	
	/**
	 * Equipment Slots
	 */
	public var equipments:Inventory;
	
	/**
	 * Trader
	 */
	public var trader:Trader;
	
	
	/**
	 * State Machine
	 */
	//TODO public var states:FiniteStateMachine;
	
	/**
	 * DOT controller
	 */
	public var damageOverTime:DamageOverTime;
	
	/**
	 * Weapon controller
	 */
	public var weapon:WeaponController;
	
	/**
	 * Dialogue Initializer
	 */
	public var dialogInitializer:DialogInitializer;
	
	/**
	 * Mouse Handler
	 */
	public var mouse:MouseHandler;
	
	/**
	 * Time to recover from a hit (in seconds)
	 */
	public var hitRecoverTime:Float = 0.2;
	
	/**
	 * Time to recover after attacking (in seconds)
	 */
	public var attackRecoverTime:Float = 0.2;
	
	/**
	 * @private
	 * Internal timer to recover this entity
	 */
	private var recoverTimer:FlxTimer;
	
	/**
	 * Current recover state (hit or attack)
	 */
	public var recoverState:RecoverState;		

	/**
	 * Constructor
	 * @param	x
	 * @param	y
	 */
	public function new(x:Float = 0, y:Float = 0) 
	{
		super(x, y);				
		
		recoverState = RNormal;
	}
	
	public function enableHitBox(width:Int, height:Int):Void 
	{
		if (hitBox == null)		
			hitBox = new HitBox(this, width, height);
	}
	
	public function enablePickupBox(width:Int, height:Int):Void 
	{
		if (pickupBox == null)	
			pickupBox = new HitBox(this, width, height);
	}
	/**
	 * Enable weapon
	 */
	public function enableWeapon():Void
	{
		if (weapon == null)
		weapon = new WeaponController(this);	
	}
	
	/**
	 * Enable DOT
	 */
	public function enableDamageOverTime():Void
	{
		if (damageOverTime == null)
			damageOverTime = new DamageOverTime();	
	}
	
	/**
	 * Enable inventory
	 */ 
	public function enableInventory():Void
	{
		if (inventory == null)
			inventory = Inventory.create();			
	}
	
	/**
	 * Enable equipments
	 */
	public function enableEquipments():Void
	{
		if (equipments == null)
			equipments = Inventory.create();
	}
	
	/**
	 * Enable trader
	 * @param	hasInventory
	 */
	public function enableTrader(hasInventory:Bool):Void
	{
		if (hasInventory && inventory == null)
			FlxG.log.warn("Entity.enableTrader: hasInventory is set to true but inventory is null");
		
		trader = new Trader(hasInventory ? inventory : null);
	}
	
	/**
	 * Enable AI
	 */
	public function enableAI():Void
	{
		if (ai == null)
			ai = new AIController(this);
	}
	
	/**
	 * Enable Stat
	 */
	public function enableStat():Void
	{
		if (stat == null)
			stat = new StatController();	
	}
	
	/**
	 * Enable state machine
	 */
	/*public function enableStates():Void
	{
		if (states == null)
			states = new FiniteStateMachine(this);			
	}*/
	
	/**
	 * Enable Dialogue Initializer
	 * After than you can call entity.dialogueInitializer.start();
	 */
	public function enableDialogueInitializer():Void
	{
		if (dialogInitializer == null)
			dialogInitializer = new DialogInitializer();
	}
	
	private inline function enableMouse(pixelPerfect:Bool = false):Void
	{
		mouse = new MouseHandler(this, pixelPerfect);		
	}
	
	/**
	 * Override
	 */
	override public function update():Void 
	{
		super.update();
		
		if(ai != null)
			ai.update();
	}
	
	/**
	 * Override
	 */
	override public function destroy():Void 
	{		
		super.destroy();
		
		if (ai != null)
			ai.destroy();
			
		if (hitBox != null)	
			hitBox.destroy();
			
		if (pickupBox != null)
			pickupBox.destroy();
			
		if (weapon != null)
			weapon.destroy();
	}
	
	/**
	 * Override	 
	 */
	override public function kill():Void 
	{
		super.kill();
		
		if (hitBox != null)
			hitBox.kill();
			
		if (pickupBox != null)
			pickupBox.kill();
	}
	
	/**
	 * Override	 
	 */	
	override public function revive():Void 
	{
		super.revive();
		
		if (hitBox != null)
			hitBox.revive();
		
		if (pickupBox != null)
			pickupBox.revive();
	}		
	
	/**
	 * Override	 
	 */
	override public function hurt(Damage:Float):Void 
	{
		super.hurt(Damage);
		
		if (hitRecoverTime > 0)
		{
			recoverState = RHit;
			freeze(hitRecoverTime);
		}
		
		DamageText.showAtObject(this, Damage+"");
	}
			
	/**
	 * Freeze the character from motion & attacks
	 */
	public function freeze(duration:Float):Void
	{
		moves = false;
		velocity.set();
		if (recoverTimer != null)
			recoverTimer.reset(Math.max(duration, recoverTimer.timeLeft));
		else 
			recoverTimer = FlxTimer.start(duration, function(?t) recover());
	}
	
	/**
	 * Recover from freeze
	 */
	private function recover():Void
	{
		moves = true;
		recoverTimer = null;
		recoverState = RNormal;
	}
	
	/**
	 * Set a target for this entity
	 * @param	target
	 */
	public inline function engage(target:Entity):Void
	{
		this.target = target;
	}
	
	/**
	 * Remove the target for this entity
	 */
	public inline function disengage():Void
	{
		this.target = null;
	}
	
	
}

enum RecoverState
{
	RNormal;
	RAttack;
	RHit;
}