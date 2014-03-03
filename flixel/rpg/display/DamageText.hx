package flixel.rpg.display;

import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.rpg.core.RpgEngine;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.tweens.motion.LinearMotion;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Kevin
 */
class DamageText extends FlxText //FlxTypedGroup<FlxText>
{
	public static var group(default, null):FlxTypedGroup<DamageText>;
	
	private var motionTween:LinearMotion;
	private var alphaTween:ColorTween;
	
	/**
	 * Call this function once before using DamageText.showAtObject()
	 * @param	state
	 */
	public static function init():Void
	{
		if (group == null)
			group = new FlxTypedGroup<DamageText>();
	}
	
	/**
	 * Constructor
	 */
	public function new()
	{
		super(0, 0, 30);		
		alignment = "center";		
		
		motionTween = new LinearMotion(onMotionTweenComplete,FlxTween.PERSIST);
		motionTween.setObject(this);
		FlxTween.manager.add(motionTween);
		
		alphaTween = new ColorTween(onAlphaTweenComplete, FlxTween.PERSIST);
		FlxTween.manager.add(alphaTween);		
	}
	
	/**
	 * Display damage text at [object]
	 * @param	object
	 * @param	value
	 */
	public static function showAtObject(object:FlxObject, value:String):Void
	{
		var textBox = group.getFirstAvailable();
		
		if (textBox == null)
		{
			RpgEngine.levels.current.add(textBox = new DamageText());
		}
				
		var fromX = object.x + (object.width - textBox.width) * 0.5 + FlxRandom.intRanged( -10, 10);
		var fromY = object.y + FlxRandom.intRanged( -10, 5);
		var toY = fromY - 20;
		
		textBox.alpha = 1;
		textBox.text = value;
		textBox.setPosition(fromX, fromY);
		textBox.exists = true;
		
		textBox.motionTween.setMotion(fromX, fromY, fromX, toY, 1, true, FlxEase.expoOut);
	}
	
	
	/**
	 * Complete callback for the motionTween. Starts fading out the text.
	 * @param	motionTween
	 */
	private function onMotionTweenComplete(motionTween:FlxTween):Void
	{
		alphaTween.tween(0.5, color, color, 1, 0, FlxEase.quartOut, this);
	}
	
	/**
	 * Complete callback for the alphaTween. Remove the text.
	 * @param	alphaTween
	 */
	private function onAlphaTweenComplete(alphaTween:FlxTween):Void
	{
		exists = false;
	}
}