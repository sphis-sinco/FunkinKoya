package koya.frontend.play.characters.bf;

import koya.backend.AssetPaths;

class BFSpooky extends BFRegular
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool)
	{
		super(x, y, isPlayer, 'bf-spooky');
	}

	override function getFrames()
	{
		frames = AssetPaths.getAnimateAtlas('characters/boyfriend-spooky', 'characters');
	}
}
