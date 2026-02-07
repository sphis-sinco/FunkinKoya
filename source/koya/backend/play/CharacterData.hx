package koya.backend.play;

import koya.backend.play.ObjectData.ObjectAnimationData;

typedef CharacterData =
{
	type:String,

	?iconChar:String,
	?dataPathPrefix:String,

	?flipX:Bool,
	?flipAnimationsAsPlayer:Bool,

	?animations:Array<ObjectAnimationData>,
}
