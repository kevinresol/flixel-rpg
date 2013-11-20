package flixel.rpg.display ;

import flixel.addons.ui.FlxButtonPlus;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * ...
 * @author Kevin
 */
class Panel extends FlxSubState
{
	
	private var testSprite:FlxSprite;
	private var closeButton:FlxButtonPlus;

	public function new() 
	{
		super(0x33ff0000, true);
		
		var b = new FlxButton(200, 300, "Test");
		add(b);
		
		closeButton = new FlxButtonPlus(300, 300, close, null, "Close");
		closeButton.scrollFactor.set();
		add(closeButton);
		
		testSprite = new FlxSprite(0, 70);
		testSprite.scrollFactor.set();
		testSprite.velocity.x = 10;
		add(testSprite);
		
		
	}
	
}