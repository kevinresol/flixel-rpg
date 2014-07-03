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
	?autoRespond:Bool,
}

typedef ResponseData =
{
	text:String,
	?dialog:String, // show another dialog
	?requirement:String, // (hscript) conditions for this response to be available
	?events:Array<String>,  // list of event to be dispatched
}
