package flixel.rpg.damage;
import flixel.FlxSprite;
import flixel.rpg.data.Data;
import flixel.rpg.weapon.Bullet;
import game.entity.Enemy;
import flixel.rpg.system.HitBox;

/**
 * ...
 * @author Kevin
 */
class BulletCallbacks
{
	private static var callbackMap:Map<Int, Dynamic->Dynamic->Void>;	
	
	public static function init():Void
	{
		if (callbackMap != null)
			return;
		
		callbackMap = new Map < Int, Dynamic->Dynamic->Void > ();
		
		for (wd in Data.weaponData)
		{
			var f = Reflect.getProperty(BulletCallbacks, wd.collideCallback);
			callbackMap.set(wd.id, f);
		}
	}
	
	public static function collideCallback(bullet:Bullet, hitBox:HitBox):Void
	{
		if (callbackMap == null)
			init();
			
		callbackMap.get(bullet.ID)(bullet, hitBox.parent);
	}
	
	
	private static function singleHitAndVanish(bullet:Bullet, target:FlxSprite):Void
	{
		bullet.kill();
		target.hurt(1);
		
		engageIfNeeded(bullet, target);
	}
	
	private static function continuousHit(bullet:Bullet, target:FlxSprite):Void
	{
		if (bullet.isReloaded(target))
		{
			target.hurt(1);
			bullet.reload(target);
			engageIfNeeded(bullet, target);
		}
	}
	
	private static inline function engageIfNeeded(bullet:Bullet, target:FlxSprite):Void
	{
		if (Std.is(target, Enemy))
		{
			var e = cast(target, Enemy);
			if (!e.engaged)
				e.engage(cast(bullet.weapon.parent));
		}
	}
	
	
}