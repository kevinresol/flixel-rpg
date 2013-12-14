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
	public static var groups:GroupManager;
	
	public static function init(state:FlxState):Void
	{
		state.add(groups = new GroupManager());
		DamageText.init(state);	
	}

	public static function collide():Void
	{		
		//Don't walk into walls
		FlxG.collide(groups.characters, groups.level.blocks);
		
		//Don't shoot through walls
		FlxG.collide(groups.bullets, groups.level.blocks, bulletCollideWall);
		
		//Bullets should hit the target!
		FlxG.overlap(groups.allyBullets, groups.enemyHitBoxes, BulletCallbacks.collideCallback, returnTrue);		
		FlxG.overlap(groups.enemyBullets, groups.allyHitBoxes, BulletCallbacks.collideCallback, returnTrue);
		
		//Pickup magnet
		FlxG.overlap(groups.playerPickupBoxes, groups.pickups, Pickup.moveTowardsPlayer, returnTrue);		
		
		//Take Pickups
		FlxG.overlap(groups.player, groups.pickups, Pickup.picked , returnTrue);
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