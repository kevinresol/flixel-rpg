package flixel.rpg.display.lighting;

import flash.display.BlendMode;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

/**
 * ...
 * @author Kevin
 */
class Darkness extends FlxSprite
{
	private var fillColor:UInt;
	private var rect:Rectangle;
	
	public var needToDraw:Bool;
		
	public function new(color:UInt)
	{		
		super(0, 0);
		fillColor = color;
		makeGraphic(FlxG.width, FlxG.height, fillColor);
		rect = new Rectangle(0, 0, FlxG.width, FlxG.height);
		scrollFactor.set();
		blend = BlendMode.MULTIPLY;
	}
	
	override public function draw():Void 
	{		
		if(needToDraw)		
			pixels.fillRect(rect, fillColor);
		
		super.draw();
	}
	
	
	
}