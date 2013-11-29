package flixel.rpg.requirement;
import flixel.rpg.entity.manager.GroupManager;
import flixel.rpg.inventory.Inventory;

/**
 * ...
 * @author Kevin
 */
class ItemRequirement implements IRequirement
{
	public var inventory:Inventory;
	public var id:Int;
	public var count:Int;

	public function new(id:Int, count:Int) 
	{
		this.id = id;
		this.count = count;
	}
	
	/* INTERFACE flixel.rpg.requirement.IRequirement */
	
	public function fulfilled():Bool 
	{
		if (count == 0)
			return true;
			
		//If inventory is not assigned, use the current player's inventory
		if (inventory == null)
		{
			if (GroupManager.player == null)
				return false;
			inventory = GroupManager.player.inventory;
		}
			
		//Final validation
		if (inventory == null)
			return false;		
		
		return inventory.countStack(id) >= count;
	}
	
}

typedef ItemRequirementData =
{
	id:Int,
	count:Int
}