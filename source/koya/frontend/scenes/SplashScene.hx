package koya.frontend.scenes;

import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.util.typeLimit.NextState;

class SplashScene extends MusicBeatState
{
	public var nextScene:NextState;

	override public function new(nextScene:NextState)
	{
		super();

		this.nextScene = nextScene;
	}

	override function create()
	{
		super.create();

		FlxG.sound.play(AssetPaths.music('TitleJingle'));
	}
}
