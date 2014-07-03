package flixel.rpg.data;

/**
 * ...
 * @author Kevin
 */
typedef EventData = 
{
	id:String,
	?script:String, // hscript actions
	?conditions:Array<String>, // conditions for this event to be triggered
	?events:Array<String>, // trigger other events
	?on:Array<String>, // list of conditions to be switched on
	?off:Array<String>, // list of conditions to be switched off
}