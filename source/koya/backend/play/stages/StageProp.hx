package koya.backend.play.stages;

enum abstract StagePropLayerType(String) from String to String
{
	var BACK = 'back';
	var FRONT = 'front';
}

enum abstract StagePropAnimationType(String) from String to String
{
	var PREFIX = 'prefix';
	var FRAME_LABEL = 'frame_label';
}

typedef StageProp =
{
	?img:String,

	?sparrow:String,
	?atlas:String,
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
	
	?prefix:String,
	?frame_label:String,
	
	?looped:Bool,
	?fps:Int,
}
