package flixel.rpg.data;
import haxe.Unserializer;

/**
 * Data hub for loading various data in hxon format
 * @author Kevin
 */
@:build(flixel.rpg.data.DataMacro.build("assets/data"))
class Data
{
	public var weaponData:Array<WeaponData>;
	public var tradeData:Array<TradeData>;
	
	
	public function new()
	{
		
	}
	
	public function loadWeaponData(data:String):Void
	{
		if (weaponData == null)
			weaponData = Unserializer.run(data);
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
	
	
	public function loadTradeData(data:String):Void
	{
		if (tradeData == null)
			tradeData = Unserializer.run(data);
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