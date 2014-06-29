package flixel.rpg.data;

/**
 * ...
 * @author Kevin
 */
typedef TradeData = 
{
	id:String,
	reward:Array<TradeItemData>,
	cost:Array<TradeItemData>
}

typedef TradeItemData = 
{
	id:String,
	count:Int
}
