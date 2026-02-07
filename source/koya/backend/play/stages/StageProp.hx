package koya.backend.play.stages;

enum abstract StagePropLayerType(String) from String to String
{
	var BACK = 'back';
	var FRONT = 'front';
}

typedef StageProp =
{
	?img:String,

	?sparrow:String,
	?animations:Array<StagePropAnimations>,
	
	?scrollFactor:Array<Int>,
	?scale:Array<Float>,

	?layerType:StagePropLayerType,
	?layer:Int,
}

typedef StagePropAnimations =
{
	type:String,
	name:String,
	prefix:String
}
