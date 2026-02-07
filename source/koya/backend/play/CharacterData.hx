package koya.backend.play;

import koya.backend.play.ObjectData.ObjectAnimationData;

/** Character Type **/
enum abstract CharacterType(String) from String to String
{
	var SPARROW = 'sparrow';
	var ATLAS = 'atlas';
}

typedef CharacterData =
{
	type:CharacterType,

	?iconChar:String,
	?imagePath:String,
	?dataPathPrefix:String,

	?flipX:Bool,
	?flipAnimationsAsPlayer:Bool,

	?animations:Array<ObjectAnimationData>,
}
