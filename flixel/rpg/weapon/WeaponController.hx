package flixel.rpg.weapon;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;
import flixel.rpg.weapon.Bullet;
import haxe.Unserializer;

/**
 * Allows an entity to has different weapons and provides functions to switch between them.
 * @author Kevin
 */
class WeaponController
{
	public static var data:Array<WeaponData>;
	
	public var group:FlxTypedGroup<FlxTypedGroup<FlxBullet>>;
	
	private var weapons:Map<Int, FlxWeapon>;
	private var entity:Entity;	
	
	/**
	 * Reference of the fire function
	 */
	private var fireWeaponAtMouse:Void->Bool;
	private var fireWeaponAtTarget:FlxSprite-> Bool;
	
	
	public var currentWeapon(default, null):FlxWeapon;
	
	public var currentWeaponID(default, set):Int;
	
	public static function loadData(dataString:String):Void
	{
		if (data == null)
			data = Unserializer.run(dataString);
	}
	
	public static function getData(id:Int):WeaponData
	{
		if (data == null)
			throw "loadWeaponData first";
			
		for (w in data)
		{
			if (w.id == id)
				return w;
		}
		return null;
	}
	
	/**
	 * Constructor
	 * @param	entity
	 */
	public function new(entity:Entity) 
	{
		this.entity = entity;
		group = new FlxTypedGroup<FlxTypedGroup<FlxBullet>>();		
		weapons = new Map<Int, FlxWeapon>();
	}
	
	/**
	 * Get the weapon by ID. Will create one if not yet done so
	 * @param	id
	 * @return	FlxWeaponX instance
	 */
	public function getWeapon(id:Int):FlxWeapon
	{
		if (weapons.get(id) == null)
			createWeapon(id);
		
		return weapons.get(id);
	}
	
	
	/**
	 * Try to fire the weapon. The actual cooldown algoritm is in FlxWeapon.
	 */
	public function attack():Void
	{		
		var fired:Bool = false;
		
		//Automatically select the correct fire function to call (see switchWeapon)
		if (fireWeaponAtMouse != null)
			fired = fireWeaponAtMouse();
		else if (fireWeaponAtTarget != null)
			fired = fireWeaponAtTarget(entity.target);
			
		//Weapon fired, freeze the entity due to attack recover
		if (fired)
		{
			if (entity.attackRecoverTime > 0)
			{
				entity.recoverState = RAttack;
				entity.freeze(entity.attackRecoverTime);
			}
		}
	}
	
	/**
	 * Called by the entity
	 */
	public function destroy():Void
	{		
		//TODO: destroy each FlxWeaponX		
		group.destroy();
		weapons = null;
		entity = null;	
		fireWeaponAtMouse = null;
		fireWeaponAtTarget = null;
		currentWeapon = null;
	}
	
	
	/**
	 * Create the weapon
	 * @param	id
	 */
	private function createWeapon(id:Int):Void
	{
		var wd = getData(id);
		var w = new FlxWeapon(wd.name, entity, Bullet, id);
		weapons.set(id, w);
		
				
		w.makePixelBullet(10);
		
		w.setBulletOffset(entity.origin.x, entity.origin.y);
		w.setFireRate(wd.fireRate);
		w.setBulletSpeed(wd.bulletSpeed);
		w.bulletDamage = wd.bulletDamage;
		w.group.setAll("reloadTime", wd.bulletReloadTime);
		
		w.setBulletBounds(RpgEngine.levels.current.obstacles.getBounds());
		
		group.add(w.group);
	}	
	
	/**
	 * Switch Weapon
	 * @param	id
	 */
	private function switchWeapon(id:Int):Void
	{
		//Set current weapon
		currentWeapon = getWeapon(id);
		
		//Get the fireMode of this weapon from data
		var fireMode:String = getData(id).fireMode;
		
		//Reset the fire functions
		fireWeaponAtMouse = null;
		fireWeaponAtTarget = null;
		
		//Map the fire functions
		if(fireMode == "fireAtMouse")
			fireWeaponAtMouse = Reflect.getProperty(currentWeapon, fireMode);
		else if(fireMode == "fireAtTarget")
			fireWeaponAtTarget = Reflect.getProperty(currentWeapon, fireMode);		
	}
	
	
	private function set_currentWeaponID(v:Int):Int
	{
		if (currentWeaponID == v)
			return v;
		
		switchWeapon(v);			
		return currentWeaponID = v;
	}
	
}

typedef WeaponData = 
{
	id:Int,
	name:String,
	collideCallback:String,
	fireMode:String,	
	fireRate:Int,	
	bulletSpeed:Int,	
	bulletDamage:Int,	
	bulletReloadTime:Float,
	image:String

}

