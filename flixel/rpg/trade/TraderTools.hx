package flixel.rpg.trade;
import flixel.rpg.data.TradeData.TradeItemData;
import flixel.rpg.inventory.Inventory;
import flixel.rpg.inventory.InventoryItem;
/**
 * Supporting tools for Trader
 * @author Kevin
 */
class TraderTools
{
	
	/**
	 * Test if an inventory is able to perform a trade. 
	 * True means the inventory has all the costs and it can hold the rewards after removing the costs.
	 * @param	inventory inventory to test
	 * @param	cost cost of the trade
	 * @param	reward reward of the trade
	 * @return
	 */
	public static function canTrade(inventory:Inventory, cost:Array<TradeItemData>, reward:Array<TradeItemData>):Bool
	{
		var tempInventory = inventory.clone();		
		
		//Try to remove the cost from the inventory
		for (c in cost)
		{
			if (!tempInventory.removeItem(c.id, c.count)) //not enough
			{
				tempInventory.put();
				return false; 
			}
		}		
		
		//Try to add the traded items to inventory
		for (i in reward)
		{
			if (!tempInventory.addItem(InventoryItem.get(i.id, i.count))) //cannot add, not enough space
			{
				tempInventory.put();
				return false; 
			}
		}
		
		tempInventory.put();
		return true;		
	}
}