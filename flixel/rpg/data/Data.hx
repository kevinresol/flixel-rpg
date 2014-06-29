package flixel.rpg.data;
#if macro
import haxe.macro.Expr;
#else
import haxe.Unserializer;
import openfl.Assets;

/**
 * Data hub for loading various data in hxon format
 * @author Kevin
 */
@:build(flixel.rpg.data.DataMacro.build("assets/data"))
class Data
{	
	public var entity(default, null):Array<EntityData>;
	public var dialog(default, null):Array<DialogData>;
	public var weapon(default, null):Array<WeaponData>;
	public var trade(default, null):Array<TradeData>;
	public var item(default, null):Array<InventoryItemData>;
	
	public var entityData(never, set):String;
	public var dialogData(never, set):String;
	public var weaponData(never, set):String;
	public var tradeData(never, set):String;
	public var itemData(never, set):String;
	
	public function new()
	{
		
	}
	
	public function getEntity(id:String):EntityData 		Macro.getData(entity, id);
	public function getDialog(id:String):DialogData 		Macro.getData(dialog, id);
	public function getWeapon(id:String):WeaponData 		Macro.getData(weapon, id);
	public function getTrade(id:String):TradeData 			Macro.getData(trade, id);
	public function getItem(id:String):InventoryItemData 	Macro.getData(item, id);
	
	private function set_entityData(v:String):String 	{entity = Unserializer.run(v); return v;}
	private function set_dialogData(v:String):String 	{dialog = Unserializer.run(v); return v;}
	private function set_weaponData(v:String):String 	{weapon = Unserializer.run(v); return v;}
	private function set_tradeData(v:String):String 	{trade = Unserializer.run(v); return v;}
	private function set_itemData(v:String):String 		{item = Unserializer.run(v); return v;}
	
}
#end

private class Macro
{
	macro public static function getData<TData, TID>(data:ExprOf<Array<TData>>, id:ExprOf<TID>):ExprOf<TData>
	{
		return macro 
		{
			for (d in $data)
				if (d.id == $id)
					return d;
			
			return null;
		}
	}
}


