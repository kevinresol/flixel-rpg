package flixel.rpg.display;

import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.math.FlxRandom;
import flixel.rpg.core.RpgEngine;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * A popup text displaying damage numbers
 * @author Kevin
 */
class DamageText extends FlxText //FlxTypedGroup<FlxText>
{
	public static var group(default, null):FlxTypedGroup<DamageText>;
	
	private var motionTweenOptions:TweenOptions;
	private var alphaTweenOptions:TweenOptions;
	
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
		motionTweenOptions = { type:FlxTween.ONESHOT, ease:FlxEase.expoOut, complete:onMotionTweenComplete };
		alphaTweenOptions = { type:FlxTween.ONESHOT, ease:FlxEase.expoOut, complete:onAlphaTweenComplete };			
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
		
		FlxTween.linearMotion(textBox, fromX, fromY, fromX, toY, 1, true, textBox.motionTweenOptions);
	}
	
	
	/**
	 * Complete callback for the motionTween. Starts fading out the text.
	 * @param	motionTween
	 */
	private function onMotionTweenComplete(motionTween:FlxTween):Void
	{
		FlxTween.num(1, 0, 0.5, alphaTweenOptions, tweenAlpha);
	}
	
	/**
	 * Complete callback for the alphaTween. Remove the text.
	 * @param	alphaTween
	 */
	private function onAlphaTweenComplete(alphaTween:FlxTween):Void
	{
		exists = false;
	}
	
	private function tweenAlpha(v:Float):Void
	{
		alpha = v;
	}
}