package flixel.rpg.trade;
import flixel.rpg.data.Data;
import flixel.rpg.entity.factory.Factory;
import flixel.rpg.inventory.Inventory;

/**
 * A Vendor can trade items.
 * @author Kevin
 */
class Vendor
{
	/**
	 * Trade items
	 * @param	invetory
	 * @param	id trade id (defined by loadTradeData)
	 * @return	return true if the trade is successful
	 */
	public static function trade(inventory:Inventory, id:Int):Bool
	{
		var tradeData:TradeData = Data.getTradeData(id);
		
		if (!inventory.canTrade(tradeData.cost, tradeData.reward))
			return false;
		
		//Deduct the cost from inventory
		for (c in tradeData.cost)
		{
			trace(c.id, c.count);
			inventory.removeItem(c.id, c.count);
		}
		
		//Add the traded items to inventory
		for (i in tradeData.reward)
		{
			inventory.addItem(Factory.createInventoryItem(i.id, i.count));
		}
		
		return true;
	}
	
}