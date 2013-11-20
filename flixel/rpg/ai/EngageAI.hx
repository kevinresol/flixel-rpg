package flixel.rpg.ai;
import flixel.FlxSprite;
import flixel.rpg.entity.Entity;
import flixel.rpg.entity.manager.GroupManager;
import flixel.util.FlxMath;

/**
 * Engages the player when it get too close or when it is being attacked
 * @author Kevin
 */
class EngageAI extends AI
{
	public var passive:Bool = false;
	public var engageRange:Float = 80;	
	
	/**
	 * TODO
	 */
	public var targets:Array<Entity>;
	
	public function new() 
	{
		super();
	}
	
	override public function update():Void 
	{
		//Check distance with the player if not yet engaged
		if (!passive && entity.target == null && FlxMath.isDistanceWithin(entity, GroupManager.player, engageRange))/* FlxMath.distanceBetween(this, Reg.player) < engageRange*/
			entity.engage(GroupManager.player);
		
		if (entity.target != null)
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