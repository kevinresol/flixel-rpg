package flixel.rpg.entity;
import flixel.rpg.entity.StateSwitch.GroupMode;

/**
 * An entity with a stateSwitch
 * @author Kevin
 */
class StateSwitchEntity<T:EnumValue> extends Entity
{
	public var stateSwitch(default, null):StateSwitch<T>;

	public function new(x:Float=0, y:Float=0, defaultState:T, ?targetState:T, ?groupMode:GroupMode) 
	{
		super(x, y);
		stateSwitch = new StateSwitch<T>(this, defaultState, targetState, groupMode);
	}	
}