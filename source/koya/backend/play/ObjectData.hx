package koya.backend.play;

/** Animation Types **/
enum abstract ObjectAnimationTypes(String) from String to String
{
	var PREFIX = 'prefix';
	var FRAME_LABEL = 'frame_label';
}

/** Animation Data **/
typedef ObjectAnimationData =
{
	type:ObjectAnimationTypes,
	name:String,

	?prefix:String,
	?frame_label:String,

	?looped:Bool,
	?fps:Int,
}