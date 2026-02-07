package koya.frontend.scenes;

import flixel.util.typeLimit.NextState;

class SplashScene extends MusicBeatState
{
	public var nextScene:NextState;

	override public function new(nextScene:NextState)
	{
		super();

		this.nextScene = nextScene;
	}
}
