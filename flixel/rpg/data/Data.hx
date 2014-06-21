package flixel.rpg.data;
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
	public function new(entityData:String)
	{
		entity = Unserializer.run(entityData);
	}
	
	public function getEntity(id:String):EntityData
	{
		for (e in entity)
			if (e.id == id)
				return e;
				
		return null;
	}
}

typedef EntityData = 
{
	id:String,
	name:String,
	immovable:Bool,
	health:Float,
	graphic:GraphicData,
	ai:Array<AIData>,
	maxVelocity:{x:Float, y:Float},
	hitbox: { width:Int, height:Int },
}

typedef GraphicData = 
{ 
	asset:String, 
	width:Int, 
	height:Int, 
	centerOffsets:Bool, 
	defaultAnimation:String, 
	animations:Array<AnimationData> 
}

typedef AIData = 
{
	name:String,
	className:String,
	params:Array<Dynamic>,
}

typedef AnimationData = 
{
	name:String,
	frameRate:Int,
	looped:Bool,
	frames:Array<Int>,
}

typedef DialogData = 
{
	
}



