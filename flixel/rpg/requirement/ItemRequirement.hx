package flixel.rpg.requirement;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.inventory.Inventory;
import flixel.rpg.requirement.RequirementFactory.RequirementData;

/**
 * A requirement that is fulfilled by possessing the specified item
 * 
 * The default RequirementFactory accepts the following JSON:
	 * {
	 * 		"type":"item", 
	 * 		"params":
	 * 		{
	 * 			"id":1, 
	 * 			"count":2,
	 * 			"inventory":"inventory" (optional; possible values: "inventory" and "equipments")
	 * 		}
	 * }
 * @author Kevin
 */
class ItemRequirement implements IRequirement
{
	/**
	 * The item id
	 */
	public var id:Int;
	
	/**
	 * Required amount of the item
	 */
	public var count:Int;

	
	private var inventoryType:String;
	
	/**
	 * Constructor 
	 * @param	id	Item id
	 * @param	count	Required amount of the item
	 * @param	inventory	
	 */
	public function new(id:Int, count:Int, inventoryType:String) 
	{
		this.id = id;
		this.count = count;
		this.inventoryType = inventoryType;
	}
	
	/* INTERFACE flixel.rpg.requirement.IRequirement */
	
	public function fulfilled():Bool 
	{
		if (count == 0)
			return true;		
		
		var inventory = switch(inventoryType)
		{
			case "inventory": RpgEngine.groups.player.inventory;
			case "equipments": RpgEngine.groups.player.equipments;
			default: throw 'Invalid requirement param - inventory:$inventoryType';
		}
		
		// validation
		if (inventory == null)
			return false;		
		
		return inventory.has(id, count);
	}
	
}
