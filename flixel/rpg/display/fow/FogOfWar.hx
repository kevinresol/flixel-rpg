package flixel.rpg.display.fow;

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
class FogOfWar extends FlxSprite
{
	private var state:FlxState;
	private var fillColor:UInt;
	private var rect:Rectangle;
	
	private var lights:Array<Light>;
		
	public function new(state:FlxState, color:UInt)
	{		
		super(0, 0);
		this.state = state;
		this.fillColor = color;
		makeGraphic(FlxG.width, FlxG.height, 0xaa000000);
		rect = new Rectangle(0, 0, FlxG.width, FlxG.height);
		scrollFactor.set();
		blend = BlendMode.MULTIPLY;
		lights = [];
	}
	
	public function addLight():Light
	{
		state.remove(this);
		var l = new Light(this);
		lights.push(l);
		state.add(l);
		state.add(this);
		return l;
	}
	
	
	override public function draw():Void 
	{
		var needToDraw:Bool = false;
		for (l in lights)
		{
			if (l.moved)
				needToDraw = true;
		}
		
		for (l in lights)
			l.needToDraw = needToDraw;
			
		if(needToDraw)		
			pixels.fillRect(rect, fillColor);
		
		super.draw();
	}
}