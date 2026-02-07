package koya.backend.play.stages;

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
