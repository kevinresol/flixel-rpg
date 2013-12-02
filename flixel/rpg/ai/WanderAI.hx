package flixel.rpg.ai;
import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;

/**
 * An AI that allows the entity to wander (move randomly) around. Stop for a moment, and wanders again
 * @author Kevin
 */
class WanderAI extends AI
{
	
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
	
	/**
	 * @private
	 * Flag to indicate if the entity is in wandering mode. Basically it means
	 * that the entity is not "actively" moving. Note that the entity may be standing still
	 * even isWandering == true, because there is a pause between each wander moves. 
	 */
	private var isWandering:Bool;
	
	/**
	 * @private
	 * The time interval to next wander move
	 */
	private var nextWanderInterval:Float;
	
	/**
	 * @private
	 * The center point of wander. The entity will wander around this point
	 */
	private var wanderCenter:FlxPoint;
	
	/**
	 * @private
	 * The elpased time since last wander move. Used with nextWanderInterval to
	 * trigger next mvoe
	 */
	private var timeSinceLastMove:Float = 0;	
	
	/**
	 * @private
	 * X location of previous frame. Used to determine if the entity is moving.
	 * Used by timeSinceLastMove
	 */
	private var prevX:Float;
	
	/**
	 * @private
	 * Y location of previous frame. Used to determine if the entity is moving.
	 * Used by timeSinceLastMove
	 */
	private var prevY:Float;
	
	/**
	 * @private
	 * The target location of a wander move
	 */
	private var targetLocation:FlxPoint; 
	
	/**
	 * @private
	 * A timer to stop a wander move, so that it will stop at the targetLocation
	 */
	private var stopTimer:FlxTimer;

	/**
	 * Constructor
	 */
	public function new() 
	{
		super();
		setNextWanderInterval();
		targetLocation = new FlxPoint();
		wanderCenter = new FlxPoint();
	}
	
	/**
	 * Override
	 */
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