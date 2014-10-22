package flixel.rpg.ai;
import flixel.math.FlxMath;
import flixel.rpg.entity.Entity;

/**
 * An AI that engages the player (TODO: or a list of targets) when the parent entity
 * gets too close or when the parent entity is being attacked
 * @author Kevin
 */
class EngageAI extends AI
{
	/**
	 * Passive entity will not engage by itself.
	 */
	public var passive:Bool = false;
	
	/**
	 * Engage upon being attacked
	 */
	public var returnFire:Bool = true;	
	
	/**
	 * Engage range of this entity, only relevant when 'passive' is set to false
	 */
	public var range:Float = 80;
	
	/**
	 * When the target is in range, delay to engage (in seconds);
	 */
	public var delay(default, set):Float = 0;
	
	/**
	 * A list of targets to check against. Engage if any of them if in range
	 */
	public var targets:Array<Entity>;
	
	/**
	 * A map to store the elapsed in-range time for each possible targets
	 */
	public var elapsedList:Map<Entity, Float>;
	
	/**
	 * Constructor
	 * @param	?targets
	 */
	public function new(?targets:Array<Entity>) 
	{
		super();

		if(targets == null)
			this.targets = [];
		else
			this.targets = targets;
	}
	
	/**
	 * Override
	 */
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
				
		//Try to aquire a target when currently not engaged
		if (entity.target == null)
		{
			//being attacked, return fire~!
			if (returnFire && entity.lastHitBy != null)
				entity.engage(entity.lastHitBy);
			
			//Check distance with the potential targets if not yet engaged
			if (!passive)
			{
				for (e in targets)
				{				
					if (FlxMath.isDistanceWithin(entity, e, range))
					{
						// Engage immediately if there is no delay
						if (delay == 0)
						{
							entity.engage(e);						
							break;
						}
						else // Check elapsed time since in range
						{
							var s = elapsedList.get(e);
							
							if (s == null)
								s = 0;
							else
								s += elapsed;
								
							
							if (s >= delay)
							{
								entity.engage(e);
								
								// Already engaged, no need to store the elapsed time anymore
								for (k in elapsedList.keys())
									elapsedList.remove(k);
									
								break;
							}
							else
								elapsedList.set(e, s);
						}
					}
					else // Not in range
					{
						if(elapsedList != null)
							elapsedList.remove(e);
					}
				}
			}
		}
		
		//Update target info
		else
		{
			//target is dead
			if (!entity.target.alive)
			{
				//remove the target
				entity.disengage();
				
				//stop moving
				entity.velocity.set();
			}
		}
	}
	
	private function set_delay(v:Float):Float
	{
		if (v == delay)
			return v;
			
		if (v != 0 && elapsedList == null)
			elapsedList = new Map();
			
		return delay = v;
	}
}