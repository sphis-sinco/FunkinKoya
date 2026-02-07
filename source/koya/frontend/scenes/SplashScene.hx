package koya.frontend.scenes;

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

	override public function new(nextScene:NextState)
	{
		super();

		this.nextScene = nextScene;
	}

	override function create()
	{
		super.create();

		FlxG.sound.play(AssetPaths.music('TitleJingle'), 1.0, false, null, true, function() {
			FlxTimer.wait(1, function() {
				FlxG.switchState(nextScene);
			});
		});
		Conductor.changeBPM(120.0);

		add(splashTexts);
	}

	override function stepHit()
	{
		super.stepHit();

		var splash:String = splashText[curStep] ?? '';

		if (splash == '') return;
		
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
