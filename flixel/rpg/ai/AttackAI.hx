package flixel.rpg.ai;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;
import flixel.util.FlxMath;
import flixel.util.FlxVelocity;

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
			//Attack target if engaged and in range
			switch(entity.recoverState)
			{
				case RNormal:
					if (FlxMath.isDistanceWithin(entity, RpgEngine.groups.player, attackRange))
						entity.weapon.attack();
				default:
			}
		}
	}
	
}