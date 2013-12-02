package flixel.rpg.core;
import flixel.FlxG;
import flixel.FlxState;
import flixel.rpg.damage.BulletCallbacks;
import flixel.rpg.display.DamageText;
import flixel.rpg.entity.manager.GroupManager;
import flixel.rpg.entity.Pickup;
import flixel.rpg.weapon.Bullet;

/**
 * ...
 * @author Kevin
 */
class RpgEngine
{
	
	public static function init(state:FlxState):Void
	{
		GroupManager.init(state);
		DamageText.init(state);	
	}

	public static function collide():Void
	{		
		//Don't walk into walls
		FlxG.collide(GroupManager.characters, GroupManager.level.blocks);
		
		//Don't shoot through walls
		FlxG.collide(GroupManager.bullets, GroupManager.level.blocks, bulletCollideWall);
		
		//Bullets should hit the target!
		FlxG.overlap(GroupManager.allyBullets, GroupManager.enemyHitBoxes, BulletCallbacks.collideCallback, returnTrue);		
		FlxG.overlap(GroupManager.enemyBullets, GroupManager.allyHitBoxes, BulletCallbacks.collideCallback, returnTrue);
		
		//Pickup magnet
		FlxG.overlap(GroupManager.playerPickupBoxes, GroupManager.pickups, Pickup.moveTowardsPlayer, returnTrue);		
		
		//Take Pickups
		FlxG.overlap(GroupManager.player, GroupManager.pickups, Pickup.picked , returnTrue);
	}
	
	
	private static function bulletCollideWall(bullet:Bullet, map):Void
	{
		bullet.kill();
	}
	
	
	private static function returnTrue(?p1, ?p2):Bool
	{
		return true;
	}
	
	
}