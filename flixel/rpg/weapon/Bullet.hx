package flixel.rpg.weapon;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

/**
 * A very special kind of bullet. A bullet can hit the same target multiple times
 * @author Kevin
 */
class Bullet extends FlxBullet
{
	public var reloadTime:Float = 0.3;	
	
	public var weapon(default, null):FlxTypedWeapon<Bullet>;
	/**
	 * A map to store the reloaded property for each targets
	 */
	private var reloadedMap:Map<FlxSprite, Bool>;

	public function new(weapon:FlxTypedWeapon<Bullet>, id:Int)
	{
		super();
		ID = id;
		this.weapon = weapon;
		reloadedMap = new Map();
	}
	
	/**
	 * For bullets that perform continuous hit, we don't want the bullets
	 * to hurt the target on every update. So we add a "reloaded" property
	 * to it. Even the bullet overlap the target on every updates, the target
	 * will only be hurt every "reloadTime" seconds. The "reloaded" property is
	 * specific to each target.
	 * @param	target
	 * @return  true if reloaded (ready to hit)
	 */
	public function isReloaded(target:FlxSprite):Bool
	{
		var result = reloadedMap.get(target);
		return (result == null) || result;
	}
	
	/**
	 * Set "reloaded" to false and add a timer to reset "reloaded" to true after
	 * "reloadTime" seconds.
	 * @param	target
	 */
	public function reload(target:FlxSprite):Void
	{
		reloadedMap.set(target, false);
		new FlxTimer(reloadTime, function(_) reloadedMap.set(target, true));
	}
	
	override public function kill():Void 
	{
		super.kill();
		reloadedMap = new Map<FlxSprite, Bool>(); //can be optimized?
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		reloadedMap = null;
	}
	
}