package flixel.rpg.ai;
import flixel.rpg.entity.manager.GroupManager;
import flixel.util.FlxMath;
import flixel.util.FlxVelocity;
import flixel.rpg.entity.Entity;

/**
 * An AI that auto attacks the target of the parent entity (if target != null)
 * @author Kevin
 */
class AttackAI extends AI
{
	/**
	 * The entity will only attack if the target is within this range
	 */
	public var attackRange:Float = 60;

	/**
	 * Constructor
	 */
	public function new() 
	{
		super();
		
	}
	
	/**
	 * Override
	 */
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