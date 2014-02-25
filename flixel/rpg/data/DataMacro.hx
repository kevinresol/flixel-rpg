package flixel.rpg.data;

import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.Serializer;
import sys.FileSystem;
import sys.io.File;
 
using haxe.macro.ExprTools;
using StringTools;


class DataMacro
{
    inline static var QUOTED_FIELD_PREFIX = "@$__hx__";
	
	public static function build(folderPath:String):Array<Field>
	{
		var fields = Context.getBuildFields();
		
		var outputFolder = folderPath + "/output/";		
		
		if (!FileSystem.exists(outputFolder))	
			FileSystem.createDirectory(outputFolder);
		
		for (f in FileSystem.readDirectory(folderPath))
		{
			if (f.indexOf(".hxon") == -1)
				continue;
				
			var filePath = folderPath + "/" + f;
			var e = parseFile(filePath);
			validateExpr(e);
			var v = extractValue(e);
			var s = Serializer.run(v);
			var pos = Context.currentPos();
			
			//var tstr = TPath( { pack : [], name : "String", params : [], sub : null } );
			//fields.push( { name : f.split(".")[0], doc : null, meta : [], access : [APublic], kind : FVar(tstr, macro $v { s } ), pos : pos } );
			
			var o = File.write(outputFolder + f.replace("hxon", "txt"), false);
			o.writeString(s);
			o.close();
		}
		
		
		return fields;
	} 
 
    static function parseFile(path:String):Expr
    {
        var content = sys.io.File.getContent(path);
        var pos = Context.makePosition({min: 0, max: 0, file: path});
        return Context.parseInlineString(content, pos);
    }
 
    static function validateExpr(e:Expr):Void
    {
        switch (e.expr)
        {
            case EConst(CInt(_) | CFloat(_) | CString(_) | CIdent("true" | "false" | "null")):// constants				
            case EBlock([]): // empty object
            case EObjectDecl(fields): for (f in fields) validateExpr(f.expr);
            case EArrayDecl(exprs): for (e in exprs) validateExpr(e);
            default:
                throw new Error("Invalid JSON expression: " + e.toString(), e.pos);
        }
    }
 
    static function extractValue(e:Expr):Dynamic
    {
        switch (e.expr)
        {
            case EConst(c):
                switch (c)
                {
                    case CInt(s):
                        var i = Std.parseInt(s);
                        return (i != null) ? i : Std.parseFloat(s); // if the number exceeds standard int return as float
                    case CFloat(s):
                        return Std.parseFloat(s);
                    case CString(s):
                        return s;
                    case CIdent("null"):
                        return null;
                    case CIdent("true"):
                        return true;
                    case CIdent("false"):
                        return false;
                    default:
                }
            case EBlock([]):
                return {};
            case EObjectDecl(fields):
                var object = {};
                for (field in fields)
                    Reflect.setField(object, unquoteField(field.field), extractValue(field.expr));
                return object;
            case EArrayDecl(exprs):
                return [for (e in exprs) extractValue(e)];
            default:
        }
        throw new Error("Invalid JSON expression: " + e.toString(), e.pos);
    }
 
    // see https://github.com/HaxeFoundation/haxe/issues/2642
    static function unquoteField(name:String):String
    {
        return (name.indexOf(QUOTED_FIELD_PREFIX) == 0) ? name.substr(QUOTED_FIELD_PREFIX.length) : name;
    }
}