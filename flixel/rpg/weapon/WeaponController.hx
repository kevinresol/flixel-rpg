package flixel.rpg.weapon;
import flixel.addons.weapon.FlxBullet;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.data.WeaponData;
import flixel.rpg.entity.Entity;
import flixel.rpg.util.Hash;
import flixel.rpg.weapon.Bullet;
import flixel.util.helpers.FlxBounds;
import haxe.Unserializer;

/**
 * Allows an entity to has different weapons and provides functions to switch between them.
 * @author Kevin
 */
class WeaponController
{
	public var group:FlxTypedGroup<FlxTypedGroup<Bullet>>;
	
	private var weapons:Map<String, FlxTypedWeapon<Bullet>>;
	private var entity:Entity;	
	
	/**
	 * Reference of the fire function
	 */
	private var fireWeaponAtMouse:Void->Bool;
	private var fireWeaponAtTarget:FlxSprite-> Bool;
	
	
	public var currentWeapon(default, null):FlxTypedWeapon<Bullet>;
	
	public var currentWeaponID(default, set):String;
	
	public static inline function getData(id:String):WeaponData
	{
		return RpgEngine.current.data.getWeapon(id);
	}
	
	/**
	 * Constructor
	 * @param	entity
	 */
	public function new(entity:Entity) 
	{
		this.entity = entity;
		group = new FlxTypedGroup();		
		weapons = new Map();
	}
	
	/**
	 * Get the weapon by ID. Will create one if not yet done so
	 * @param	id
	 * @return	FlxWeaponX instance
	 */
	public function getWeapon(id:String):FlxTypedWeapon<Bullet>
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
	private function createWeapon(id:String):Void
	{
		var wd = getData(id);
		
		var offset = entity.origin.copyTo();
		
		var w = new FlxTypedWeapon<Bullet>(
			wd.name, 
			function(w) 
			{
				var b = new Bullet(w, Hash.stringToIntHash(id));
				b.makeGraphic(2, 2);
				return b;
			}, 
			PARENT(entity, new FlxBounds(offset, offset)), 
			SPEED(new FlxBounds<Float>(wd.bulletSpeed, wd.bulletSpeed))
		);
		
		w.fireRate = wd.fireRate;
		w.bulletDamage = wd.bulletDamage;
		w.bounds = entity.rpg.level.obstacles.getBounds(); //TODO what if current level changed?
		w.group.forEach(function(b) b.reloadTime = wd.bulletReloadTime);
		
		weapons.set(id, w);
		group.add(w.group);
	}	
	
	/**
	 * Switch Weapon
	 * @param	id
	 */
	private function switchWeapon(id:String):Void
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
	
	
	private function set_currentWeaponID(v:String):String
	{
		if (currentWeaponID == v)
			return v;
		
		switchWeapon(v);			
		return currentWeaponID = v;
	}
	
	
}


