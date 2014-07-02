package flixel.rpg.core;
import flixel.math.FlxMath;
import flixel.rpg.entity.StateSwitch.GroupMode;
import flixel.rpg.entity.Toggle.ToggleState;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.util.FlxPool;
import hscript.Expr;
import hscript.Expr.Error;
import hscript.Interp;
import hscript.Parser;
import openfl.Assets;

/**
 * Scripting Engine
 * @author Kevin
 */
class RpgScripting implements IFlxDestroyable
{
	private static var pool:FlxPool<RpgScripting> = new FlxPool<RpgScripting>(RpgScripting);
	private static var parser = new Parser();
	
	public var variables(get, never):Map<String, Dynamic>;
	
	private var interp:FlxInterp;

	private function new() 
	{
		interp = new FlxInterp();
	}
	
	public static function parseString(script:String):Expr
	{
		try
		{
			return parser.parseString(script);
		}
		catch (e:Error)
		{
			trace(e, " at line " + parser.line + " of: \n" + script);
			return null;
		}
	}
	
	public static function get(rpg:RpgEngine):RpgScripting
	{
		var scripting = pool.get();
		
		scripting.variables.set("rpg", rpg);
        scripting.variables.set("FlxMath", FlxMath);
        scripting.variables.set("Assets", Assets);
        scripting.variables.set("FlxG", FlxG);
        scripting.variables.set("ToggleState", ToggleState); //TODO remove this?
        scripting.variables.set("GroupMode", GroupMode); //TODO remove this?
		
		return scripting;
	}
	
	public function put():Void
	{
		pool.put(this);
	}
	
	
	public inline function executeAst(ast:Expr):Dynamic
	{
		try
		{
			return interp.execute(ast);	
		}
		catch (e:Dynamic)
		{
			FlxG.log.error(e);
			return null;
		}
	}
	
	public inline function executeScript(script:String):Dynamic
	{
		return executeAst(parseString(script));	
	}
	
	
	public function destroy():Void 
	{
		for (key in interp.variables.keys())
			interp.variables.remove(key);
	}
	
	private inline function get_variables():Map<String, Dynamic> 
	{
		return interp.variables;
	}
}

/**
 * Go thorugh getters/setters when accessing properties (not a default feature in the original Interp)
 */
private class FlxInterp extends Interp
{
	override function get( o : Dynamic, f : String ) : Dynamic {
        if( o == null ) throw hscript.Expr.Error.EInvalidAccess(f);
        return Reflect.getProperty(o,f);
    }

    override function set( o : Dynamic, f : String, v : Dynamic ) : Dynamic {
        if( o == null ) throw hscript.Expr.Error.EInvalidAccess(f);
        Reflect.setProperty(o,f,v);
        return v;
    }
}

