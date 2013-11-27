package flixel.rpg.display.lighting;
import flash.display.BitmapData;

/**
 * ...
 * @author Kevin
 */
class ImageLight extends Light
{

	public function new(bitmapData:BitmapData) 
	{
		super();
		resizePixels(bitmapData.width, bitmapData.height, false);
		pixels = bitmapData.clone();
	}
	
}