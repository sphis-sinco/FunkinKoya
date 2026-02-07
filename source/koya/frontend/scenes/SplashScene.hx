package koya.frontend.scenes;

import flixel.sound.FlxSound;
import koya.frontend.ui.AtlasText;
import flixel.group.FlxGroup.FlxTypedGroup;
import koya.backend.CoolUtil;
import koya.backend.Conductor;
import flixel.util.FlxTimer;
import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.util.typeLimit.NextState;

using StringTools;

class SplashScene extends MusicBeatState
{
	public var nextScene:NextState;

	public var jingle:FlxSound;

	override public function new(nextScene:NextState)
	{
		super();

		this.nextScene = nextScene;
	}

	override function create()
	{
		super.create();

		jingle = new FlxSound().loadEmbedded(AssetPaths.music('TitleJingle'), false, false, function() {
			FlxTimer.wait(1, function() {
				FlxG.switchState(nextScene);
			});
		});
		Conductor.changeBPM(120.0);
		jingle.play();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (jingle != null) Conductor.songPosition = jingle.time;

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
	}
}
