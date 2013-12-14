package flixel.rpg.requirement;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.manager.GroupManager;
import flixel.rpg.inventory.Inventory;

/**
 * A requirement that is fulfilled by possessing the specified item
 * @author Kevin
 */
class ItemRequirement implements IRequirement
{
	/**
	 * The inventory to check
	 */
	public var inventory:Inventory;
	
	/**
	 * The item id
	 */
	public var id:Int;
	
	/**
	 * Required amount of the item
	 */
	public var count:Int;

	/**
	 * Constructor 
	 * @param	id	Item id
	 * @param	count	Required amount of the item
	 * @param	inventory	
	 */
	public function new(id:Int, count:Int, ?inventory:Inventory) 
	{
		this.id = id;
		this.count = count;
		this.inventory = inventory;
	}
	
	/* INTERFACE flixel.rpg.requirement.IRequirement */
	
	public function fulfilled():Bool 
	{
		if (count == 0)
			return true;
			
		//If inventory is not assigned, use the current player's inventory
		if (inventory == null)
		{
			if (RpgEngine.groups.player == null)
				return false;
			inventory = RpgEngine.groups.player.inventory;
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