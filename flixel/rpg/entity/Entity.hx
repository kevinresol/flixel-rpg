package flixel.rpg.entity;
import flixel.FlxSprite;
import flixel.rpg.ai.AIController;
import flixel.rpg.damage.DamageOverTime;
import flixel.rpg.damage.WeaponController;
import flixel.rpg.display.DamageText;
import flixel.rpg.inventory.Inventory;
import flixel.rpg.system.HitBox;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Kevin
 */
class Entity extends FlxSprite
{
	public var hitBox:HitBox;
	public var pickupBox:HitBox;
	
	public var target(default, null):FlxSprite;
	
	public var engaged(get, never):Bool;
	private inline function get_engaged():Bool { return target != null;}
	
	public var ai:AIController;	
	public var inventory:Inventory;
	public var equipments:Inventory;
	public var damageOverTime:DamageOverTime;
	public var weapon:WeaponController;
	
	public var hitRecoverTime:Float = 0.2;
	public var attackRecoverTime:Float = 0.2;
	private var recoverTimer:FlxTimer;
	
	public var recoverState:Int;	
	
	public static inline var STATE_NORMAL:Int = 0; 
	public static inline var STATE_HIT_RECOVER:Int = 1; 
	public static inline var STATE_ATTACK_RECOVER:Int = 2;

	public function new(x:Float = 0, y:Float = 0) 
	{
		super(x, y);
		damageOverTime = new DamageOverTime();
		weapon = new WeaponController(this);		
		inventory = new Inventory();			
		equipments = new Inventory();		
		ai = new AIController(this);
		
		hitBox = new HitBox(this, 20, 20);
		pickupBox = new HitBox(this, 70, 70);
	}	
	
	override public function update():Void 
	{
		super.update();			
		ai.update();
	}
	
	override public function destroy():Void 
	{		
		super.destroy();
		ai.destroy();		
		hitBox.destroy();
		pickupBox.destroy();
		weapon.destroy();
	}
	
	override public function kill():Void 
	{
		super.kill();
		hitBox.kill();
		pickupBox.kill();
	}
	
	override public function revive():Void 
	{
		super.revive();
		hitBox.revive();
		pickupBox.revive();
	}	
	
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
	public function engage(target:Entity):Void
	{
		this.target = target;
	}
	
	/**
	 * Remove the target for this entity
	 */
	public function disengage():Void
	{
		this.target = null;
	}
	
	
}