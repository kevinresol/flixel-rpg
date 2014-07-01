package flixel.rpg.data;

/**
 * ...
 * @author Kevin
 */
typedef EntityData = 
{
	id:String,
	name:String,
	immovable:Bool,
	health:Float,
	graphic:GraphicData,
	ai:Array<AIData>,
	dialog:String,
	maxVelocity:{x:Float, y:Float},
	hitbox: { width:Int, height:Int }, // map collision box
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