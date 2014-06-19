package flixel.rpg.core;
import hscript.Interp;
import hscript.Parser;

/**
 * Scripting Engine
 * @author Kevin
 */
class RpgScript
{
	public var variables(get, never):Map<String, Dynamic>;
	
	private var interp:Interp;
	private var parser:Parser;

	public function new() 
	{		
		parser = new Parser();
		interp = new Interp();		
	}
	
	public function execute(script:String):Dynamic
	{
		var ast = parser.parseString(script);
		return interp.execute(ast);
	}
	
	private function get_variables():Map<String, Dynamic> 
	{
		return interp.variables;
	}
}