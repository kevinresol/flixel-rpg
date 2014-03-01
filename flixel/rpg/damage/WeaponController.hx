package flixel.rpg.damage;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;
import flixel.rpg.weapon.Bullet;

/**
 * ...
 * @author Kevin
 */
class WeaponController
{
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
	private function set_currentWeaponID(v:Int):Int
	{
		if (currentWeaponID == v)
			return v;
		
		switchWeapon(v);			
		return currentWeaponID = v;
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
	 * Create the weapon
	 * @param	id
	 */
	private function createWeapon(id:Int):Void
	{
		var wd = RpgEngine.data.getWeaponData(id);
		var w = new FlxWeapon(wd.name, entity, Bullet, id);
		weapons.set(id, w);
		
				
		w.makePixelBullet(10);
		
		w.setBulletOffset(entity.origin.x, entity.origin.y);
		w.setFireRate(wd.fireRate);
		w.setBulletSpeed(wd.bulletSpeed);
		w.bulletDamage = wd.bulletDamage;
		w.group.setAll("reloadTime", wd.bulletReloadTime);
		
		w.setBulletBounds(RpgEngine.groups.level.obstacles.getBounds());
		
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
		var fireMode:String = RpgEngine.data.getWeaponData(id).fireMode;
		
		//Reset the fire functions
		fireWeaponAtMouse = null;
		fireWeaponAtTarget = null;
		
		//Map the fire functions
		if(fireMode == "fireAtMouse")
			fireWeaponAtMouse = Reflect.getProperty(currentWeapon, fireMode);
		else if(fireMode == "fireAtTarget")
			fireWeaponAtTarget = Reflect.getProperty(currentWeapon, fireMode);		
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
}

