package flixel.rpg.display.fow;

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
	private var fogOfWar:FogOfWar;
	private var prevScreenXY:FlxPoint;
	private var screenXY:FlxPoint;
	
	public var moved:Bool;
	public var needToDraw:Bool;

	public function new(fogOfWar:FogOfWar) 
	{
		super(0,0,new BitmapData(300,300,true,0));
		
		this.fogOfWar = fogOfWar;
		
		
		FlxSpriteUtil.drawCircle(this, 150, 150, 150, 0xaaddffff);
		
		blend = BlendMode.SCREEN;
		screenXY = new FlxPoint();
		prevScreenXY = new FlxPoint();
	}
	
	override public function update():Void 
	{
		getScreenXY(screenXY);		
		moved = ((screenXY.x != prevScreenXY.x) || (screenXY.y != prevScreenXY.y));		
		prevScreenXY.copyFrom(screenXY);			
		
		super.update();
	}
	
	override public function draw():Void 
	{
		if(needToDraw)		
			fogOfWar.stamp(this,Std.int(screenXY.x)-150, Std.int(screenXY.y)-150);
		
	}
	
}