package flixel.rpg.display;

import flixel.FlxObject;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Kevin
 */
class DamageText extends FlxTypedGroup<FlxText>
{
	private static var motionTweenOptions:TweenOptions;	
	private static var alphaTweenOptions:TweenOptions;
	private static var alphaTweenValues:Dynamic;	
	
	private static var damageText:DamageText;
	
	/**
	 * Call this function once before using DamageText.showAtObject()
	 * @param	state
	 */
	public static function init(state:FlxState):Void
	{
		if (damageText == null)
			state.add(damageText = new DamageText());
	}
	
	/**
	 * Constructor
	 */
	public function new()
	{
		super();
		
		//Prepare the tween objects
		motionTweenOptions = { complete:onMotionTweenComplete, type:FlxTween.ONESHOT, ease:FlxEase.expoOut };		
		alphaTweenOptions = { complete:onAlphaTweenComplete, type:FlxTween.ONESHOT, ease:FlxEase.quartOut };
		alphaTweenValues = { alpha:0 };		
	}
	
	/**
	 * Display damage text at [object]
	 * @param	object
	 * @param	value
	 */
	public static function showAtObject(object:FlxObject, value:String):Void
	{
		var textBox = damageText.getFirstAvailable();
		
		if (textBox == null)
		{
			textBox = new FlxText(0, 0, 30);
			textBox.alignment = "center";
			damageText.add(textBox);
		}
				
		var fromX = object.x + (object.width - textBox.width) * 0.5 + FlxRandom.intRanged( -10, 10);
		var fromY = object.y + FlxRandom.intRanged( -10, 5);
		var toY = fromY - 20;
		
		textBox.alpha = 1;
		textBox.text = value;
		textBox.setPosition(fromX, fromY);
		textBox.exists = true;
		
		var motionTween = FlxTween.multiVar(textBox, { y:toY }, 1, motionTweenOptions );
		motionTween.userData = textBox;		
	}
	
	/**
	 * Complete callback for the motionTween. Starts fading out the text.
	 * @param	motionTween
	 */
	private function onMotionTweenComplete(motionTween:FlxTween):Void
	{
		var alphaTween = FlxTween.multiVar(motionTween.userData, alphaTweenValues, 0.5, alphaTweenOptions);
		alphaTween.userData = motionTween.userData;
	}
	
	/**
	 * Complete callback for the alphaTween. Remove the text.
	 * @param	alphaTween
	 */
	private function onAlphaTweenComplete(alphaTween:FlxTween):Void
	{
		cast(alphaTween.userData, FlxText).exists = false;
	}
}