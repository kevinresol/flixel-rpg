package flixel.rpg.weapon;

import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;

/**
 * ...
 * @author Kevin
 */
class Weapon extends FlxWeapon
{
	var id:Int;
	var bulletType:Dynamic;

	public function new(ID:Int, Name:String, BulletType:Dynamic, ?ParentRef:FlxSprite) 
	{
		super(Name, ParentRef);
		id = ID;
		bulletType = BulletType;
	}
	
	
	
	
	/**
	 * Makes a pixel bullet sprite (rather than an image). You can set the width/height and color of the bullet.
	 * 
	 * @param	Quantity	How many bullets do you need to make? This value should be high enough to cover all bullets you need on-screen *at once* plus probably a few extra spare!
	 * @param	Width		The width (in pixels) of the bullets
	 * @param	Height		The height (in pixels) of the bullets
	 * @param	Color		The color of the bullets. Must be given in 0xAARRGGBB format
	 * @param	OffsetX		When the bullet is fired if you need to offset it on the x axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
	 * @param	OffsetY		When the bullet is fired if you need to offset it on the y axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
	 */
	override public function makePixelBullet(Quantity:Int, Width:Int = 2, Height:Int = 2, Color:Int = 0xffffffff, OffsetX:Int = 0, OffsetY:Int = 0):Void
	{
		group = new FlxTypedGroup<FlxBullet>(Quantity);
		
		for (b in 0...Quantity)
		{
			//var tempBullet:FlxBulletX = new FlxBulletX(this, id);
			var tempBullet:FlxBullet = Type.createInstance(bulletType, [this, id]);
			tempBullet.makeGraphic(Width, Height, Color);
			group.add(tempBullet);
		}
		
		_positionOffset.x = OffsetX;
		_positionOffset.y = OffsetY;
	}
	
	/**
	 * Makes a bullet sprite from the given image. It will use the width/height of the image.
	 * 
	 * @param	Quantity		How many bullets do you need to make? This value should be high enough to cover all bullets you need on-screen *at once* plus probably a few extra spare!
	 * @param	Image			The image used to create the bullet from
	 * @param	OffsetX			When the bullet is fired if you need to offset it on the x axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
	 * @param	OffsetY			When the bullet is fired if you need to offset it on the y axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
	 * @param	AutoRotate		When true the bullet sprite will rotate to match the angle of the parent sprite. Call fireFromParentAngle or fromFromAngle to fire it using an angle as the velocity.
	 * @param	Frame			If the image has a single row of square animation frames on it, you can specify which of the frames you want to use here. Default is -1, or "use whole graphic"
	 * @param	Rotations		The number of rotation frames the final sprite should have.  For small sprites this can be quite a large number (360 even) without any problems.
	 * @param	AntiAliasing	Whether to use high quality rotations when creating the graphic. Default is false.
	 * @param	AutoBuffer		Whether to automatically increase the image size to accomodate rotated corners. Default is false. Will create frames that are 150% larger on each axis than the original frame or graphic.
	 */
	override public function makeImageBullet(Quantity:Int, Image:Dynamic, OffsetX:Int = 0, OffsetY:Int = 0, AutoRotate:Bool = false, Rotations:Int = 16, Frame:Int = -1, AntiAliasing:Bool = false, AutoBuffer:Bool = false):Void
	{
		group = new FlxTypedGroup<FlxBullet>(Quantity);
		
		_rotateToAngle = AutoRotate;
		
		for (b in 0...Quantity)
		{
			//var tempBullet:FlxBulletX = new FlxBulletX(this, id);
			var tempBullet:FlxBullet = Type.createInstance(bulletType, [this, id]);
			
			#if flash
			if (AutoRotate)
			{
				tempBullet.loadRotatedGraphic(Image, Rotations, Frame, AntiAliasing, AutoBuffer);
			}
			else
			{
				tempBullet.loadGraphic(Image);
			}
			#else
			tempBullet.loadGraphic(Image);
			tempBullet.animation.frameIndex = Frame;
			tempBullet.antialiasing = AntiAliasing;
			#end
			group.add(tempBullet);
		}
		
		_positionOffset.x = OffsetX;
		_positionOffset.y = OffsetY;
	}
	
	/**
	 * Makes an animated bullet from the image and frame data given.
	 * 
	 * @param	Quantity		How many bullets do you need to make? This value should be high enough to cover all bullets you need on-screen *at once* plus probably a few extra spare!
	 * @param	ImageSequence	The image used to created the animated bullet from
	 * @param	FrameWidth		The width of each frame in the animation
	 * @param	FrameHeight		The height of each frame in the animation
	 * @param	Frames			An array of numbers indicating what frames to play in what order (e.g. 1, 2, 3)
	 * @param	FrameRate		The speed in frames per second that the animation should play at (e.g. 40 fps)
	 * @param	Looped			Whether or not the animation is looped or just plays once
	 * @param	OffsetX			When the bullet is fired if you need to offset it on the x axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
	 * @param	OffsetY			When the bullet is fired if you need to offset it on the y axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
	 */
	override public function makeAnimatedBullet(Quantity:Int, ImageSequence:Dynamic, FrameWidth:Int, FrameHeight:Int, Frames:Array<Int>, FrameRate:Int, Looped:Bool, OffsetX:Int = 0, OffsetY:Int = 0):Void
	{
		group = new FlxTypedGroup<FlxBullet>(Quantity);
		
		for (b in 0...Quantity)
		{
			//var tempBullet:FlxBulletX = new FlxBulletX(this, id);
			var tempBullet:FlxBullet = Type.createInstance(bulletType, [this, id]);
			
			tempBullet.loadGraphic(ImageSequence, true, false, FrameWidth, FrameHeight);
			tempBullet.addAnimation("fire", Frames, FrameRate, Looped);
			
			group.add(tempBullet);
		}
		
		_positionOffset.x = OffsetX;
		_positionOffset.y = OffsetY;
	}
	
}