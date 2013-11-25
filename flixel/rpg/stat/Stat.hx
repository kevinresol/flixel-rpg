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
	
	public var effectiveValue(default, null):Int;
	
	public var maxValue:Int;
	
	public var minValue:Int;
	
	public var isValid:Bool = false;
	
	private var modifiers:Array<StatModifier>;
	
	public var dependerStats:Array<Stat>;
	
	
	
	public function new(intrinsicValue:Int, maxValue:Int, minValue:Int) 
	{
		this.intrinsicValue = intrinsicValue;
		this.maxValue = maxValue;
		this.minValue = minValue;
		
		modifiers = [];
		dependerStats = [];
	}	
	
	
	public function addModifier(modifier:StatModifier):Void
	{
		modifiers.push(modifier);
	}
	
	public function removeModifier(modifier:StatModifier):Void
	{
		modifier.remove(modifier);
	}
	
	public function addDepender(depender:Stat):Void
	{
		if (depender == null)
			throw "Stat.addDepender() - depender cannot be null";
			
		dependerStats.push(depender);
	}
	
	public function removeDepender(depender:Stat):Void
	{
		if (depender == null)
			throw "Stat.removeDepender() - depender cannot be null";
			
		dependerStats.remove(depender);
	}
	
	public function validate():Void
	{
		//This has been refreshed
		if (isValid)
			return;
		
		//Recursively refresh all stats that are depended on by this stat
		for (m in modifiers)
		{
			if (!m.dependeeStat.isValid)
				m.dependeeStat.validate();
		}		
		
		//Revert to base value
		effectiveValue = intrinsicValue;
		
		//Start updating according to the modifier formulas
		for (m in modifiers)
			m.modifierFunction(this, m.dependeeStat);
		
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
		
		for (s in dependerStats)
			s.invalidate();
	}
	
	
	
}