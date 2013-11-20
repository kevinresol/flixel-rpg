package flixel.rpg.inventory;
import flixel.util.FlxMath;
import flixel.rpg.data.Data;
import haxe.Json;

/**
 * ...
 * @author Kevin
 */
class InventoryItem
{
	public var id(default, null):Int;
	public var displayName(default, null):String;
	public var slotType(default, null):Int;
	public var maxStack(default, null):Int;
	public var stack(default, null):Int;
	public var tooltip(default, null):String;
	

	public function new(id:Int, displayName:String, slotType:Int, maxStack:Int, stack:Int = 1, tooltip:String = "") 
	{
		this.id = id;
		this.displayName = displayName;
		this.slotType = slotType;
		this.maxStack = maxStack;
		this.stack = stack;
		this.tooltip = tooltip;
	}
	
	/**
	 * Try to stack [item] to [this]. Any remaining stack will remains in the [item]
	 * @param	item
	 */
	public function addToStack(item:InventoryItem):Void
	{
		if (id != item.id)
			return;
		
		stack += item.stack;
		
		if (stack > maxStack)
		{
			item.stack = stack - maxStack;
			stack = maxStack;
		}
		else
			item.stack = 0;		
	}
	
	/**
	 * Reduce the stack by [amount]. If stack is less than num, nothing will happen and the function returns null.
	 * @param	amount
	 * @return	a StackItem instance with [amount] stack.
	 */
	public function removeFromStack(amount:Int):InventoryItem
	{
		if (stack >= amount)
		{
			stack -= amount;
			return new InventoryItem(id, displayName, slotType, maxStack, amount);
		}
		else 
			return null;		
	}
	
	public var full(get, never):Bool;
	private inline function get_full():Bool { return stack == maxStack; }
	
	public function toString():String
	{
		return displayName + " (" + stack + "/" + maxStack + ")";
	}
	
	public function destroy():Void
	{
		
	}
}
