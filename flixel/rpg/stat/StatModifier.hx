package flixel.rpg.stat;

/**
 * ...
 * @author Kevin
 */
class StatModifier
{
	
	
	public var modifierFunction:Stat->Stat->Void;
	
	public var dependerStat(default, set):Stat;
	private function set_dependerStat(v:Stat):Stat
	{		
		if (dependerStat == v)
			return v;
		
		//In dependee's point of view, depender has changed
		if (dependeeStat != null)
		{
			if (dependerStat != null) 
				dependeeStat.removeDepender(dependerStat);	
				
			if (v != null)
				dependeeStat.addDepender(v);
		}
		
		if (dependerStat != null) 
			dependerStat.removeModifier(this);
			
		if (v != null)
			v.addModifier(this);
		
		
		//invalidate the new depender
		if(v != null)
			v.invalidate();
				
		return dependerStat = v;
	}
	
	/**
	 * Depender depends on a dependee.
	 */
	public var dependeeStat(default, set):Stat;
	private function set_dependeeStat(v:Stat):Stat
	{
		if (dependeeStat == v)
			return v;
		
		//In depender's point of view, dependee has changed
		if (dependerStat != null)
		{
			if(dependeeStat != null)
				dependeeStat.removeDepender(dependerStat);
			
			if (v != null)
				v.addDepender(dependerStat);
			
			//invalidate the (current, unchanged) depender
			dependerStat.invalidate();
		}			
		
		return dependeeStat = v;
	}
	
	public function new(modiferFunction:Stat->Stat->Void, ?dependerStat:Stat, ?dependeeStat:Stat) 
	{		
		this.modifierFunction = modiferFunction;
		this.dependerStat = dependerStat;
		this.dependeeStat = dependeeStat;
	}	
	
	public function modify():Void
	{
		modifierFunction(dependerStat, dependeeStat);
	}
	
}