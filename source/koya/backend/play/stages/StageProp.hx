package koya.backend.play.stages;

/** Prop Layer **/
enum abstract StagePropLayerType(String) from String to String
{
	var BACK = 'back';
	var FRONT = 'front';
}

/** Prop Animation Types **/
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

	?alpha:Float,

	?position:Array<Float>,
	?scrollFactor:Array<Float>,

	?scale:Array<Float>,
	?scaleUpdateHitbox:Bool,

	?layerType:StagePropLayerType,
	?layer:Int,
}

/** Prop Animation Variables **/
typedef StagePropAnimations =
{
	type:StagePropAnimationType,
	name:String,

	?prefix:String,
	?frame_label:String,

	?looped:Bool,
	?fps:Int,
}
