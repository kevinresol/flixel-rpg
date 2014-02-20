package flixel.rpg.trade;
import flixel.rpg.core.Data;
import flixel.rpg.core.Factory;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.inventory.Inventory;

using flixel.rpg.trade.TraderTools;
/**
 * A Trader can trade items.
 * @author Kevin
 */
class Trader
{
	private var tradeIds:Array<Int>;
	private var inventory:Inventory;
	
	public function new(?inventory:Inventory)
	{
		//TODO hardcoded
		tradeIds = [1];
		
		this.inventory = inventory;		
	}
	
	/**
	 * Trade items
	 * @param	invetory
	 * @param	id trade id (defined by loadTradeData)
	 * @return	return true if the trade is successful
	 */
	public function trade(buyerInventory:Inventory, id:Int):Bool
	{
		var tradeData:TradeData = RpgEngine.data.getTradeData(id);
		
		if (!buyerInventory.canTrade(tradeData.cost, tradeData.reward))
			return false;
		
		//Deduct the cost from inventory
		for (c in tradeData.cost)
		{
			trace(c.id, c.count);
			buyerInventory.removeItem(c.id, c.count);
		}
		
		//Add the traded items to inventory
		for (i in tradeData.reward)
		{
			buyerInventory.addItem(RpgEngine.factory.createInventoryItem(i.id, i.count));
		}
		
		return true;
	}
	
	public function getAllTrades():Array<TradeData>
	{
		var result = [];
		for (id in tradeIds)
			result.push(RpgEngine.data.getTradeData(id));
		return result;
	}
	
	/**
	 * Return a list of available trades, taking in account the buying power of 
	 * buyerInventory and the available stocks of this trader
	 * @param	buyerInventory
	 * @return
	 */
	public function getAvailableTrades(buyerInventory:Inventory):Array<TradeData>
	{
		var result = [];
		
		// For each trades
		for (id in tradeIds)
		{
			var tradeData = RpgEngine.data.getTradeData(id);
						
			// Check if the buyer has all the costs for this trade
			for (c in tradeData.cost)
			{
				if (!buyerInventory.has(c.id, c.count))
					break;
			}			
			
			// Passed
			result.push(tradeData);
		}
		return result;
	}
	
}

