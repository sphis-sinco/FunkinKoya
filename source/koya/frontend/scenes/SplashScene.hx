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
	
	public var splash:FunkinSprite;

	override public function new(nextScene:NextState)
	{
		super();

		this.nextScene = nextScene;
	}

	override function create()
	{
		super.create();

		FlxG.sound.playMusic(AssetPaths.music('TitleJingle'), 1.0, false, null);
		FlxG.sound.music.onComplete = function() {
			FlxTimer.wait(1, function() {
				FlxG.switchState(nextScene);
			});
		};

		Conductor.changeBPM(120.0);

		splash = new FunkinSprite();
		splash.frames = AssetPaths.getAnimateAtlas('splash', 'extra');
		splash.addFrameLabelAnim('main', 'all');
		add(splash);
		splash.playAnim('main');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
	}
}
