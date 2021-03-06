package flixel.rpg.ai;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVelocity;
import flixel.util.FlxTimer;

/**
 * An AI that allows the entity to wander (move randomly) around. 
 * Supports discrete wandering, i.e. after wandering, the entity stops for a moment, and then wanders again
 * @author Kevin
 */
class WanderAI extends AI
{	
	/**
	 * Time interval between wanders. In seconds.
	 */
	public var timeInterval:Float;
	
	/**
	 * A random number applied to the time interval
	 */
	public var timeIntervalRandomRange:Float;
	
	/**
	 * The movement speed of the wandering
	 */
	public var speed:Int;
	
	/**
	 * The entity will wander around this radius from its initial position
	 */
	public var radius:Float;
	
	/**
	 * State of wandering
	 */
	private var wanderState:WanderState;
	
	/**
	 * @private
	 * The time interval to next wander move = timeInterval + random
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
	private var idledTime:Float = 0;		
	
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
	public function new(interval:Float, intervalRandom:Float, speed:Int, radius:Float) 
	{
		super();
		wanderState = WNone;
		
		this.timeInterval = interval;
		this.timeIntervalRandomRange = intervalRandom;
		setNextWanderInterval();
		
		this.speed = speed;
		this.radius = radius;		
		
		targetLocation = FlxPoint.get();
		wanderCenter = FlxPoint.get();
	}
	
	/**
	 * Override
	 */
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		// Check if entity has an target
		switch (wanderState) 
		{
			case WNone:
				// Let's start wandering if the entity has no target
				if (entity.target == null)
				{
					// Set state to idle
					wanderState = WIdle;
					
					// Set a wander center, the entity will wander around this point
					wanderCenter.set(entity.x + entity.origin.x, entity.y + entity.origin.y);					
				}
				
			case WIdle | WMove:
				// Stop wandering if entity has target
				if (entity.target != null)
				{
					// Set state to none
					wanderState = WNone;
					
					// Clear the stop timer
					if (stopTimer != null)
					{				
						stopTimer.cancel();
						stopTimer = null;
					}
				}				
		}
		
		switch (wanderState) 
		{
			case WNone | WMove:
				// do nothing
			case WIdle:
				idledTime += FlxG.elapsed;
				
				// Have been resting for some time, should start moving
				if (idledTime > nextWanderInterval)
				{
					// Set state to move
					wanderState = WMove;
					
					// Set a random destination
					var toX = wanderCenter.x + FlxG.random.float( -radius, radius);
					var toY = wanderCenter.y + FlxG.random.float( -radius, radius);
					
					// Calculate the distance and duration of the move
					var dx = toX - entity.x - entity.origin.x;
					var dy = toY - entity.y - entity.origin.y;
					var dt = Math.sqrt(dx * dx + dy * dy) / speed;
								
					// Set velocity of the entity
					targetLocation.set(toX, toY);
					FlxVelocity.moveTowardsPoint(entity, targetLocation, speed);
					
					// Use a timer to stop the entity when it reaches the target position
					stopTimer = new FlxTimer(dt, stopWander);
				}				
		}	
	}
	
	/**
	 * Stop the current move
	 * @param	timer
	 */
	private function stopWander(timer:FlxTimer):Void
	{
		// Set state to idle again
		wanderState = WIdle;		
		
		// Reset timer
		idledTime = 0;
		stopTimer = null;
		
		// Stop moving
		entity.velocity.set();
	}
	
	/**
	 * Helper function to get the next wander interval
	 */
	private inline function setNextWanderInterval():Void
	{
		nextWanderInterval = timeInterval + FlxG.random.float( -timeIntervalRandomRange / 2, timeIntervalRandomRange / 2);
	}
	
	
}

enum WanderState
{
	WIdle; // should wander, just taking a rest right now
	WMove; // actually wandering (moving)
	WNone; // not wander at all (actively moving)
}