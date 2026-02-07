package koya.backend.play.stages;

/** Camera offsets for each character **/
typedef StageCharacterCameraOffsets =
{
	?x:Float,
	?y:Float
}

typedef StageCameraOffsets =
{
	?player:StageCharacterCameraOffsets,
	?opponent:StageCharacterCameraOffsets,
}
