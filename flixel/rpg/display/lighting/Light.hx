package flixel.rpg.display.lighting;

import flash.display.BitmapData;
import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Kevin
 */
class Light extends FlxSprite
{
	public var darkness:Darkness;
	public var moved:Bool;
	public var needToDraw:Bool;

	private var prevScreenXY:FlxPoint;
	private var screenXY:FlxPoint;
	private var halfWidth:Float;
	private var halfHeight:Float;
	
	/**
	 * Constructor.
	 */
	public function new() 
	{
		super();		
		blend = BlendMode.SCREEN;
		screenXY = new FlxPoint();
		prevScreenXY = new FlxPoint();
	}
	
	/**
	 * Create a new BitmapData object of the specified size and assign it to this.pixels
	 * @param	width
	 * @param	height
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
		if(needToDraw)		
			darkness.stamp(this, Std.int(screenXY.x - halfWidth), Std.int(screenXY.y - halfHeight));
		
	}
	
}