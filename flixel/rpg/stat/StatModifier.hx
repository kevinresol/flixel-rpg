package flixel.rpg.stat;

/**
 * ...
 * @author Kevin
 */
class StatModifier
{
	
	
	public var modifierFunction:Stat->Stat->Void;
	
	public var modfiedStat(default, set):Stat;
	private function set_modfiedStat(v:Stat):Stat
	{
		if (modfiedStat == v)
		{
			return v;
		}
		
		if (v != null)
		{
			v.invalidate();
		}
		
		return modfiedStat = v;
	}
	
	/**
	 * Depender depends on a dependee.
	 */
	public var modfierStat(default, set):Stat;
	private function set_modfierStat(v:Stat):Stat
	{
		if (modfierStat == v)
		{
			return v;
		} 
		
		if (modfiedStat != null)
		{
			modfiedStat.invalidate();
		}
		
		return modfierStat = v;
	}
	
	/**
	 * 
	 * @param	modiferFunction	modifiedStat->modifierStat->Void
	 * @param	?modfiedStat	depender is modified by dependee
	 * @param	?modfierStat	dependee modifies depender
	 */
	public function new(modiferFunction:Stat->Stat->Void, ?modfiedStat:Stat, ?modfierStat:Stat) 
	{		
		this.modifierFunction = modiferFunction;
		this.modfiedStat = modfiedStat;
		this.modfierStat = modfierStat;
		
		if (modfiedStat != null) modfiedStat.addModifier(this);
		if (modfierStat != null) modfierStat.addModifier(this);
	}	
	
	public function modify():Void
	{
		if (modfiedStat != null && modfierStat != null) 
			modifierFunction(modfiedStat, modfierStat);
	}
	
	public function destroy():Void
	{
		if (modfiedStat != null) modfiedStat.removeModifier(this);
		if (modfierStat != null) modfierStat.removeModifier(this);
		
		modifierFunction = null;
		modfiedStat = null;
		modfierStat = null;
		
	}
	
}