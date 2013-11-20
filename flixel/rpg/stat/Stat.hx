package flixel.rpg.stat;
import flixel.rpg.entity.Entity;

/**
 * ...
 * @author Kevin
 */
class Stat
{
	private var entity:Entity;
	
	public function new(entity:Entity) 
	{
		this.entity = entity;
	}	
	
	public function getLowDamage():Int
	{
		return 1;
	}
	
	public function getHighDamage():Int
	{
		return 5;
	}
	
}