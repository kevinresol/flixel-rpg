package flixel.rpg.ai;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.rpg.ai.FollowAI.AccelerationMode;

/**
 * Follow the entity's target
 * @author Kevin
 */
class FollowAI extends AI
{
	public var accelerationMode:AccelerationMode;	

	public function new() 
	{
		super();
		accelerationMode = AInstant;
	}
	
	//TODO need some pathfinding to get pass obstacles
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (entity.target != null)
		{
			//Follow target
			switch(entity.recoverState)
			{
				case RNormal:
					switch(accelerationMode)
					{
						case AInstant:
							FlxVelocity.moveTowardsObject(entity, entity.target, Std.int(entity.maxVelocity.x));
						case AAccelerate(x, y):
							var a:Float = FlxAngle.angleBetween(entity, entity.target);		
							entity.acceleration.set(Math.cos(a) * x, Math.sin(a) * y);
					}
					
				default:
			}
		}
		else
		{
			entity.acceleration.set();
		}
	}
	
	
}

enum AccelerationMode
{
	AInstant;
	AAccelerate(x:Float, y:Float);
}