package flixel.rpg.entity;
import flixel.FlxSprite;
import flixel.rpg.ai.AIController;
import flixel.rpg.damage.DamageOverTime;
import flixel.rpg.damage.WeaponController;
import flixel.rpg.display.DamageText;
import flixel.rpg.inventory.Inventory;
import flixel.rpg.stat.StatController;
import flixel.rpg.system.HitBox;
import flixel.rpg.trade.Trader;
import flixel.util.FlxTimer;

/**
 * A basic entity in this RPG framework.
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
	 * DOT controller
	 */
	public var damageOverTime:DamageOverTime;
	
	/**
	 * Weapon controller
	 */
	public var weapon:WeaponController;
	
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
	public var recoverState:Int;	
	
	public static inline var STATE_NORMAL:Int = 0; 
	public static inline var STATE_HIT_RECOVER:Int = 1; 
	public static inline var STATE_ATTACK_RECOVER:Int = 2;

	/**
	 * Constructor
	 * @param	x
	 * @param	y
	 */
	public function new(x:Float = 0, y:Float = 0) 
	{
		super(x, y);
		damageOverTime = new DamageOverTime();
		weapon = new WeaponController(this);		
		inventory = Inventory.create();			
		equipments = Inventory.create();
		trader = new Trader(inventory);
		ai = new AIController(this);
		stat = new StatController();
		
		
		hitBox = new HitBox(this, 20, 20);
		pickupBox = new HitBox(this, 70, 70);
	}
	
	
	
	/**
	 * Override
	 */
	override public function update():Void 
	{
		super.update();			
		ai.update();
	}
	
	/**
	 * Override
	 */
	override public function destroy():Void 
	{		
		super.destroy();
		ai.destroy();		
		hitBox.destroy();
		pickupBox.destroy();
		weapon.destroy();
	}
	
	/**
	 * Override	 
	 */
	override public function kill():Void 
	{
		super.kill();
		hitBox.kill();
		pickupBox.kill();
	}
	
	/**
	 * Override	 
	 */	
	override public function revive():Void 
	{
		super.revive();
		hitBox.revive();
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
			recoverState = STATE_HIT_RECOVER;
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
		recoverState = STATE_NORMAL;
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