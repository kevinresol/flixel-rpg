package flixel.rpg.trade;
import flixel.rpg.core.Data;
import flixel.rpg.inventory.Inventory;

/**
 * A Vendor can trade items.
 * @author Kevin
 */
class Vendor
{
	private var tradeIds:Array<Int>;
	
	public function new()
	{
		//TODO hardcoded
		tradeIds = [1];
	}
	
	/**
	 * Trade items
	 * @param	invetory
	 * @param	id trade id (defined by loadTradeData)
	 * @return	return true if the trade is successful
	 */
	public function trade(inventory:Inventory, id:Int):Bool
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
	
	public function getAllTrades():Array<TradeData>
	{
		var result = [];
		for (id in tradeIds)
			result.push(Data.getTradeData(id));
		return result;
	}
	
	public function getAvailableTrades(inventory:Inventory):Array<TradeData>
	{
		var result = [];
		for (id in tradeIds)
		{
			var tradeData = Data.getTradeData(id);
			if (inventory.canTrade(tradeData.cost, tradeData.reward))
				result.push(tradeData);
		}
		return result;
	}
}