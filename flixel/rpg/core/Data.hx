package flixel.rpg.core;
import haxe.Json;

/**
 * ...
 * @author Kevin
 */
class Data
{

	public var weaponData:Array<WeaponData>;
	public var itemData:Array<InventoryItemData>;
	public var tradeData:Array<TradeData>;
	
	
	public function new()
	{
		
	}
	
	public function loadWeaponData(data:String):Void
	{
		weaponData = Json.parse(data);
	}
	
	public function getWeaponData(id:Int):WeaponData
	{
		if (weaponData == null)
			throw "loadWeaponData first";
			
		for (w in weaponData)
		{
			if (w.id == id)
				return w;
		}
		return null;
	}
	
	
	
	/**
	 * Load item data from json string. Call once and only once before any use 
	 * of StackItem.
	 * @param	data
	 */
	public function loadItemData(data:String):Void
	{
		itemData = Json.parse(data);
	}
	
	public function getItemData(id:Int):InventoryItemData
	{
		if (itemData == null)
			throw "loadItemData first";
			
		for (d in itemData)
		{
			if (d.id == id)
				return d;
		}			
		return null;
	}
	
	public function loadTradeData(data:String):Void
	{
		tradeData = Json.parse(data);		
	}
	
	public function getTradeData(id:Int):TradeData
	{
		if (tradeData == null)
			throw "loadTradeData first";
			
		for (d in tradeData)
		{
			if (d.id == id)
				return d;
		}
		return null;
	}
	
}

typedef TradeData = 
{
	id:Int,
	reward:Array<TradeItemData>,
	cost:Array<TradeItemData>
}

typedef TradeItemData = 
{
	id:Int,
	count:Int
}

typedef InventoryItemData =
{
	id:Int,
	displayName:String,
	maxStack:Int
}

typedef WeaponData = 
{
	id:Int,
	name:String,
	collideCallback:String,
	fireMode:String,	
	fireRate:Int,	
	bulletSpeed:Int,	
	bulletDamage:Int,	
	bulletReloadTime:Float,
	image:String

}