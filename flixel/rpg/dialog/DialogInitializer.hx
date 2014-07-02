package flixel.rpg.dialog;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.core.RpgScripting;
import flixel.rpg.entity.Entity;
import hscript.Expr;

/**
 * A component of Entity, to initialize a dialogue when 
 * a player interacts with the Entity (or by any means)
 * @author Kevin
 */
class DialogInitializer
{
	public var entity:Entity;
	
	public var script(default, set):String;
	
	private var ast:Expr;
	
	public function new(entity:Entity) 
	{
		this.entity = entity;
	}
	
	public function start():Void
	{
		var rpg = entity.rpg;
		
		// Let the system know that this dialogue is started by a initializer
		rpg.dialog.currentInitializer = this;
		
		var dialogId = rpg.scripting.executeAst(ast);
		rpg.dialog.display(dialogId);			
	}
	
	private function set_script(v:String):String
	{
		ast = RpgScripting.parseString(v);
		return script = v;
	}
}