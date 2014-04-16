package flixel.rpg.ai;
import flixel.rpg.entity.Entity;
import flixel.util.FlxMath;

//TODO add delay. Even in range, need to wait for a delay before actually engaging

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
	public var engageRange:Float = 80;	
	
	/**
	 * TODO: A list of targets to check against. Engage if any of them is in range
	 */
	public var targets:Array<Entity>;
	
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
	override public function update():Void 
	{
		super.update();
				
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
					if (FlxMath.isDistanceWithin(entity, e, engageRange))
					{
						entity.engage(e);
						break;
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
	
}
