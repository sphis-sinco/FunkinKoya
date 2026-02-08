package koya.backend.play;

enum abstract ObjectAnimationType(String) from String to String
{
	var PREFIX = 'prefix';
	var FRAME_LABEL = 'frame_label';
}


typedef ObjectAnimationData =
{
	type:ObjectAnimationType,
	name:String,

	?prefix:String,
	?frame_label:String,

	?looped:Bool,
	?fps:Int,
}
