package flixel.rpg.weapon;
import flixel.FlxSprite;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.system.HitBox;
import flixel.rpg.util.Hash;
import flixel.rpg.weapon.Bullet;

/**
 * A set of callbacks to be called when a bullet overlaps an enemy
 * @author Kevin
 */
class BulletCallbacks
{
	private static var callbackMap:Map<Int, Dynamic->Dynamic->Void>;	
	
	public static function init():Void
	{
		if (callbackMap != null)
			return;
		
		callbackMap = new Map();
		
		for (wd in RpgEngine.current.data.weapon)
		{
			var f = Reflect.getProperty(BulletCallbacks, wd.collideCallback);
			callbackMap.set(Hash.stringToIntHash(wd.id), f);
		}
	}
	
	public static function collideCallback(bullet:Bullet, hitBox:HitBox):Void
	{
		if (callbackMap == null)
			init();
			
		callbackMap.get(bullet.ID)(bullet, hitBox.parent);
		
		//For EngageAI's use
		hitBox.parent.lastHitBy = cast(bullet.weapon.parent);
	}
	
	
	private static function singleHitAndVanish(bullet:Bullet, target:FlxSprite):Void
	{
		bullet.kill();
		target.hurt(1);		
	}
	
	private static function continuousHit(bullet:Bullet, target:FlxSprite):Void
	{
		if (bullet.isReloaded(target))
		{
			target.hurt(1);
			bullet.reload(target);
		}
	}
	
	
	
}