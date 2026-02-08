package koya.backend.play.stages;

import koya.backend.play.ObjectData;

enum abstract StagePropLayerType(String) from String to String
{
	var BACK = 'back';
	var FRONT = 'front';
}

typedef StageProp =
{
	?img:String,

	?sparrow:String,
	?atlas:String,
	?animations:Array<ObjectAnimationData>,

	?alpha:Float,

	?position:Array<Float>,
	?scrollFactor:Array<Float>,

	?scale:Array<Float>,
	?scaleUpdateHitbox:Bool,

	?layerType:StagePropLayerType,
	?layer:Int,
}
