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

	public var splashText:Array<String> = CoolUtil.coolTextFile(AssetPaths.txt('data/splash'));
	public var splashTexts:FlxTypedGroup<AtlasText> = new FlxTypedGroup<AtlasText>();

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

		add(splashTexts);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Conductor.songPosition = jingle.time;
	}

	override function stepHit()
	{
		super.stepHit();

		var splash:String = splashText[curStep] ?? '';

		if (splash == '') return;

		trace('$curStep: ' + splash);

		if (splash.startsWith('-'))
		{
			if (splashTexts.members[splashTexts.length - 1] != null) splashTexts.members[splashTexts.length - 1].text += splash.substring(1);
		}
		else
		{
			var newText:AtlasText = new AtlasText(0, 0, splash, BOLD);
			newText.screenCenter();

			for (atlasText in splashTexts.members)
				atlasText.y -= newText.height;

			splashTexts.add(newText);
		}
	}
}
