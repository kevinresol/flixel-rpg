package flixel.rpg.display.lighting;
import flash.display.BitmapData;
import flash.display.GradientType;
import flash.filters.BitmapFilter;
import flash.filters.BlurFilter;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
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
	public function new(radius:Float, colors:Array<UInt>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, ?filter:BitmapFilter) 
	{
		super();		
		
		drawCircle(radius, colors, alphas, ratios, filter);		
	}
	
	public function drawCircle(radius:Float, colors:Array<UInt>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, ?filter:BitmapFilter) 
	{		
		var diameter:Int = Std.int(radius * 2);
		resizePixels(diameter, diameter);
		
		var s = FlxSpriteUtil.flashGfxSprite;
		var g = FlxSpriteUtil.flashGfx;
		
		var m = new Matrix();		
		m.createGradientBox(radius, radius, 0, -radius / 2, -radius / 2);
		
		g.clear();
		g.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, m);
		g.drawCircle(0, 0, radius);		
		
		var rect = new Rectangle( -0, -0, s.height, s.width);
		pixels.draw(s, new Matrix(1, 0, 0, 1, s.width / 2, s.height / 2), null, null, rect);
		
		if(filter != null)
			pixels.applyFilter(pixels, rect, new Point(0, 0), filter);
	}
}