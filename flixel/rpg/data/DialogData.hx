package flixel.rpg.data;

/**
 * ...
 * @author Kevin
 */
typedef DialogData = 
{
	id:String,
	name:String,
	texts:Array<String>,
	responses:Array<ResponseData>,
	?autoRespond:Bool
}

typedef ResponseData =
{
	text:String, 
	action:String, 
	?requirement:String
}
