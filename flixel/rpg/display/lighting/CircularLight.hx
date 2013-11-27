package flixel.rpg.display.lighting;
import flash.display.BitmapData;
import flixel.util.FlxSpriteUtil;

/**
 * A circular light
 * @author Kevin
 */
class CircularLight extends Light
{
	/**
	 * Constructor
	 * @param	radius	radius of the circle
	 * @param	color	color of the mask
	 */
	public function new(radius:Float, color:UInt) 
	{
		super();		
		var diameter:Int = Std.int(radius * 2);
		resizePixels(diameter, diameter);
		FlxSpriteUtil.drawCircle(this, radius, radius, radius, color);
	}
}