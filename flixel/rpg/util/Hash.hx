package flixel.rpg.util;

/**
 * ...
 * @author Kevin
 */
class Hash
{
	public static function stringToIntHash(s:String):Int
	{
		var hash = 5381;
		for (i in 0...s.length) 
		{
			var char = s.charCodeAt(i);
			hash = ((hash << 5) + hash) + char; /* hash * 33 + c */
		}
		return hash;
	}
}