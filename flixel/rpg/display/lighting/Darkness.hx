package flixel.rpg.display.lighting;

import flash.display.BlendMode;
import flash.filters.BitmapFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import state.PlayState;

/**
 * The darkness to be used in the lighting system
 * @author Kevin
 */
class Darkness extends FlxSprite
{
	/**
	 * Fill color of this darkness
	 */
	public var fillColor:UInt;
	
	/**
	 * Helper rect for fill()
	 */
	private var rect:Rectangle;
	
	private var helperPoint:Point;
	
	/**
	 * A flag to indicate if this sprite has to redraw in next draw()
	 */
	public var needToDraw:Bool;
	
	public var filter:BitmapFilter;
		
	/**
	 * Contructor
	 * @param	color	color of the darkness, with alpha channel. e.g. 0xaa000000
 	 */
	public function new(color:UInt, ?filter:BitmapFilter)
	{		
		super(0, 0);
		fillColor = color;
		makeGraphic(FlxG.width, FlxG.height, fillColor);
		rect = new Rectangle(0, 0, FlxG.width, FlxG.height);
		
		scrollFactor.set();
		blend = BlendMode.MULTIPLY;
		this.filter = filter;
		
		if (filter != null)
			helperPoint = new Point(0, 0);
	}
	
	/**
	 * Override.
	 * Refill the whole bitmapdata with fillColor if necessary
	 */
	override public function draw():Void 
	{	
		if (filter != null)
		{
			pixels.applyFilter(pixels, rect, helperPoint, filter);
			resetFrameBitmapDatas();
		}
			
		var debugDarkness = true;
		if (debugDarkness)
		{
			PlayState.debugBitmap.bitmapData = pixels.clone();				
		}
		super.draw();
		
	}
	
	public function resetFill():Void
	{
		pixels.fillRect(rect, fillColor);
	}
	
	override public function destroy():Void 
	{
		rect = null;
		super.destroy();
	}
	
	
}