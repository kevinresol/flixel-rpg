package flixel.rpg.ai;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;

/**
 * Allow the entity to wander (move randomly) around. Stop for a moment, and wanders again
 * @author Kevin
 */
class WanderAI extends AI
{
	//public static inline var MODE_
	
	/**
	 * Time interval between wanders. In seconds.
	 */
	public var timeInterval(default, set):Float = 5;
	private function set_timeInterval(v:Float):Float
	{
		timeInterval = v;
		setNextWanderInterval();
		return v;
	}
	
	/**
	 * A random number applied to the time interval
	 */
	public var timeIntervalRandomRange(default, set):Float = 1;
	private function set_timeIntervalRandomRange(v:Float):Float
	{
		timeIntervalRandomRange = v;
		setNextWanderInterval();
		return v;
	}
	
	/**
	 * The movement speed of the wandering
	 */
	public var speed:Int = 60;
	
	/**
	 * The entity will wander around this radius from its initial position
	 */
	public var radius:Float = 25;
	
	private var isWandering:Bool;
	private var nextWanderInterval:Float;
	private var wanderCenter:FlxPoint;
	
	private var timeSinceLastMove:Float = 0;	
	private var prevX:Float;
	private var prevY:Float;
	
	private var targetLocation:FlxPoint; 
	private var stopTimer:FlxTimer;

	public function new() 
	{
		super();
		setNextWanderInterval();
		targetLocation = new FlxPoint();
		wanderCenter = new FlxPoint();
	}
	
	override public function update():Void 
	{
		super.update();
		
		//No need to wander if there is a target
		if (isWandering != (entity.target == null))
		{
			//Flip the boolean
			isWandering = !isWandering;
			
			//Just started wandering
			if (isWandering)
			{				
				//Set a wander center, the entity will wander around this point
				wanderCenter.set(entity.x + entity.origin.x, entity.y + entity.origin.y);
			}			
			else //Just stopped wandering
			{
				//Clear the stop timer
				if (stopTimer != null)
				{				
					stopTimer.abort();
					stopTimer = null;
				}
			}
		}
		
		//No need to proceed if not wandering
		if (!isWandering)
			return;		
		
		//Count time if it is not moving
		if (entity.x == prevX && entity.y == prevY)
		{
			timeSinceLastMove += FlxG.elapsed;
		}
		else //It is still moving
		{
			timeSinceLastMove = 0;
			prevX = entity.x;
			prevY = entity.y;
		}
		
		//Have been standing still for some time, lets move a bit
		if (timeSinceLastMove > nextWanderInterval)
		{			
			var toX = wanderCenter.x + FlxRandom.floatRanged( -radius, radius);
			var toY = wanderCenter.y + FlxRandom.floatRanged( -radius, radius);
			
			var dx = toX - entity.x - entity.origin.x;
			var dy = toY - entity.y - entity.origin.y;
						
			//Set velocity of the entity
			targetLocation.set(toX, toY);
			FlxVelocity.moveTowardsPoint(entity, targetLocation, speed);
			
			//Use a timer to stop the entity when it reaches the target position
			stopTimer = FlxTimer.start(Math.sqrt(dx * dx + dy * dy) / speed, stopWander);
		}
		
	}
	
	/**
	 * Stop the current move
	 * @param	timer
	 */
	private function stopWander(timer:FlxTimer):Void
	{
		entity.velocity.set();
		stopTimer = null;
	}
	
	/**
	 * Helper function to get the next wander interval
	 */
	private inline function setNextWanderInterval():Void
	{
		nextWanderInterval = timeInterval + FlxRandom.floatRanged( -timeIntervalRandomRange / 2, timeIntervalRandomRange / 2);
	}
	
	
}