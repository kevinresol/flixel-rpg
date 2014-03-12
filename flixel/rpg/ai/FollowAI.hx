package flixel.rpg.ai;
import flixel.rpg.ai.FollowAI.AccelerationMode;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;

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
	
	override public function update():Void 
	{
		super.update();
		
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