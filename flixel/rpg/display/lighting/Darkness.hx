package flixel.rpg.display.lighting;

import flash.display.BlendMode;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;

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
	
	/**
	 * A flag to indicate if this sprite has to redraw in next draw()
	 */
	public var needToDraw:Bool;
		
	/**
	 * Contructor
	 * @param	color	color of the darkness, with alpha channel. e.g. 0xaa000000
 	 */
	public function new(color:UInt)
	{		
		super(0, 0);
		fillColor = color;
		makeGraphic(FlxG.width, FlxG.height, fillColor);
		rect = new Rectangle(0, 0, FlxG.width, FlxG.height);
		scrollFactor.set();
		blend = BlendMode.MULTIPLY;
	}
	
	/**
	 * Override.
	 * Refill the whole bitmapdata with fillColor if necessary
	 */
	override public function draw():Void 
	{		
		if(needToDraw)		
			pixels.fillRect(rect, fillColor);
		
		super.draw();
	}
	
	override public function destroy():Void 
	{
		rect = null;
		super.destroy();
	}
	
	
}