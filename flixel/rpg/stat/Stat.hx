package flixel.rpg.stat;
import flixel.FlxG;
import flixel.rpg.entity.Entity;
import flixel.util.FlxMath;

/**
 * ...
 * @author Kevin
 */
class Stat
{
	public var statController:StatController;	
	
	public var intrinsicValue:Int;
	
	public var effectiveValue:Int;
	
	public var maxValue:Int;
	
	public var minValue:Int;
	
	public var isValid:Bool = false;
	
	private var modifiers:Array<StatModifier>;
	
	public function new(intrinsicValue:Int, maxValue:Int, minValue:Int) 
	{
		this.intrinsicValue = intrinsicValue;
		
		this.maxValue = maxValue;
		this.minValue = minValue;
		
		modifiers = [];
	}	
	
	
	public function addModifier(modifier:StatModifier):Void
	{
		modifiers.push(modifier);
	}
	
	public function removeModifier(modifier:StatModifier):Void
	{
		modifiers.remove(modifier);
	}
	
	
	public function validate():Void
	{
		//This has been refreshed
		if (isValid)
			return;
		
		//Recursively validate all stats that are depended on by this stat
		for (m in modifiers)
		{
			if (m.modfiedStat == this && !m.modfierStat.isValid)
			{
				m.modfierStat.validate();
			}
		}		
		
		//Revert to base value
		effectiveValue = intrinsicValue;
		
		//Start updating according to the modifier formulas
		for (m in modifiers)
		{
			if (m.modfiedStat == this)
			{
				m.modify();
			}
		}
		
		//Bound the value
		if (effectiveValue > maxValue) effectiveValue = maxValue;
		if (effectiveValue < minValue) effectiveValue = minValue;	
		
		//Finished refreshing
		isValid = true;
	}
	
	public function invalidate():Void
	{
		//Already invalid
		if (!isValid)
			return;
			
		isValid = false;
		
		//Invalidates all stats that depend on this
		for (m in modifiers)
		{
			if (m.modfierStat == this)
			{
				m.modfiedStat.invalidate();
			}
		}
	}
	
	public function destroy():Void
	{
		for (m in modifiers)
		{
			m.destroy();
		}
		
		statController = null;
		modifiers = null;
	}
	
	
	
}