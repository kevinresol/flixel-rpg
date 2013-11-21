package flixel.rpg.ai;
import flixel.rpg.entity.manager.GroupManager;
import flixel.util.FlxMath;
import flixel.util.FlxVelocity;
import flixel.rpg.entity.Entity;

/**
 * ...
 * @author Kevin
 */
class AttackAI extends AI
{
	public var attackRange:Float = 60;

	public function new() 
	{
		super();
		
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (entity.target != null)
		{
			//Follow & attack target if engaged
			if (entity.recoverState == Entity.STATE_NORMAL)
			{
				FlxVelocity.moveTowardsObject(entity, entity.target, Std.int(entity.maxVelocity.x));
				if (FlxMath.isDistanceWithin(entity, GroupManager.player, attackRange))
					entity.weapon.attack();
			}
		}
	}
	
}