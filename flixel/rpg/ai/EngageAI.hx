package flixel.rpg.ai;
import flixel.rpg.entity.Entity;
import flixel.util.FlxMath;

/**
 * Engages the player when it get too close or when it is being attacked
 * @author Kevin
 */
class EngageAI extends AI
{
	public var passive:Bool = false;
	public var returnFire:Bool = true;	
	public var engageRange:Float = 80;	
	
	/**
	 * TODO
	 */
	public var targets:Array<Entity>;
	
	public function new(?targets:Array<Entity>) 
	{
		super();

		if(targets == null)
			this.targets = [];
		else
			this.targets = targets;
	}
	
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