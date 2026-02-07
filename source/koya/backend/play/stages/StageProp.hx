package koya.backend.play.stages;

enum abstract StagePropLayerType(String) from String to String
{
	var BACK = 'back';
	var FRONT = 'front';
}

enum abstract StagePropAnimationType(String) from String to String
{
	var PREFIX = 'prefix';
}

typedef StageProp =
{
	?img:String,

	?sparrow:String,
	?animations:Array<StagePropAnimations>,
	
	?position:Array<Float>,
	?scrollFactor:Array<Float>,
	?scale:Array<Float>,

	?layerType:StagePropLayerType,
	?layer:Int,
}

typedef StagePropAnimations =
{
	type:StagePropAnimationType,
	name:String,
	prefix:String,
	?looped:Bool,
	?fps:Int,
}
