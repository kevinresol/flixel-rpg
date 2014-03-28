package flixel.rpg.display.lighting;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * A light to be used in the lighting system
 * @author Kevin
 */
class Light extends FlxSprite
{
	/**
	 * A reference to darkness for stamp()
	 */
	public var darkness:Darkness;
	
	/**
	 * A flag to indicate if this sprite has moved since last update
	 */
	public var moved:Bool;
	
	/**
	 * A flag to indicate if this sprite has to redraw in next draw()
	 */
	public var needToDraw:Bool;

	/**
	 * Store previous location
	 */
	private var prevScreenXY:FlxPoint;
	
	/**
	 * Helper point to fetch current location
	 */
	private var screenXY:FlxPoint;
	
	/**
	 * Helper variable to save the half of width
	 */
	private var halfWidth:Float;
	
	/**
	 * Helper variable to save the half of height
	 */
	private var halfHeight:Float;
	
	/**
	 * Constructor.
	 */
	public function new() 
	{
		super();		
		blend = BlendMode.SCREEN;
		screenXY = FlxPoint.get();
		prevScreenXY = FlxPoint.get();
	}
	
	/**
	 * Resize this.pixels
	 * @param	width
	 * @param	height
	 * @param	newBitmapData	true to create a new BitmapData object
	 */
	private function resizePixels(width:Int, height:Int, newBitmapData:Bool = true):Void
	{		
		if(newBitmapData)
			pixels = new BitmapData(width, height, true, 0);
		halfWidth = width * 0.5;
		halfHeight = height * 0.5;
	}
	
	/**
	 * Override.
	 * Check if this sprite is moved.
	 */
	override public function update():Void 
	{
		getScreenXY(screenXY);		
		moved = ((screenXY.x != prevScreenXY.x) || (screenXY.y != prevScreenXY.y));		
		prevScreenXY.copyFrom(screenXY);			
		
		super.update();
	}
	
	/**
	 * Override.
	 * Blend this sprite to the darkness sprite
	 */
	override public function draw():Void 
	{
		if (needToDraw)
		{
			darkness.stamp(this, Std.int(screenXY.x - halfWidth), Std.int(screenXY.y - halfHeight));
			needToDraw = false;
		}
		
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		darkness = null;
		prevScreenXY = null;
		screenXY = null;
	}
	
}