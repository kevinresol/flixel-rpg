package flixel.rpg.requirement;
import flixel.rpg.inventory.Inventory;

/**
 * ...
 * @author Kevin
 */
class ItemRequirement implements IRequirement
{
	public var inventory:Inventory;
	public var requiredItems:Array<ItemRequirementData>;

	public function new() 
	{
		
	}
	
	/* INTERFACE flixel.rpg.requirement.IRequirement */
	
	public function fulfilled():Bool 
	{
		if (inventory == null || requiredItems == null)
			return false;
			
		for (i in requiredItems)
		{
			if (inventory.countStack(i.id) < i.count)
				return false;
		}
		return true;
	}
	
}

typedef ItemRequirementData =
{
	id:Int,
	count:Int
}