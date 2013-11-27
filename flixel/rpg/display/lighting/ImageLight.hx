package flixel.rpg.display.lighting;
import flash.display.BitmapData;

/**
 * A light using a bitmap as its mask
 * @author Kevin
 */
class ImageLight extends Light
{

	/**
	 * Contructor
	 * @param	bitmapData	the source bitmap data
	 */
	public function new(bitmapData:BitmapData) 
	{
		super();
		resizePixels(bitmapData.width, bitmapData.height, false);
		pixels = bitmapData.clone();
	}
	
}