package koya.frontend.scenes.play.scenes;

import koya.backend.play.ResultsData;
import koya.backend.play.Rank;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import koya.backend.Conductor;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.typeLimit.NextState;

class ResultsSubState extends MusicBeatSubstate
{
	public var nextState:NextState;

	override public function new(nextState:NextState)
	{
		super();

		this.nextState = nextState;
	}

	public var back:FunkinSprite;

	public var resultsCam:FlxCamera;

	override function create()
	{
		super.create();

		back = new FunkinSprite();
		back.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString('#FFA7E5'));

		resultsCam = new FlxCamera();

		back.cameras = [resultsCam];

		resultsCam.bgColor.alpha = 0;
		FlxG.cameras.add(resultsCam);

		back.y -= back.height;
		back.alpha = 0;

		var stepAddition = 0;

		for (object in PlayState.instance.members)
		{
			if (object != null && Reflect.fields(object).contains('alpha'))
			{
				FlxTween.tween(object, {alpha: 0}, (Conductor.stepCrochet / 1000) * (2 + stepAddition),
					{
						ease: FlxEase.quadInOut
					});
			}
			stepAddition++;
		}

		PlayState.instance.add(back);
		FlxTween.tween(back, {y: 0, alpha: 1}, (Conductor.crochet / 1000) * 4,
			{
				ease: FlxEase.quadInOut
			});

		var rank:Rank = PlayState.resultsData.grade();
		var percent:Int = Std.int(PlayState.resultsData.gradePercent() * 100);
		trace(rank + ' ($percent%)');

		var comboNumbers = new ComboNumbers(percent, FlxG.width / 2.2, (cn) -> {
			remove(cn);
			cn.destroy();
		});
		comboNumbers.cameras = [resultsCam];
		add(comboNumbers);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && back.alpha == 1) FlxG.switchState(nextState);
	}
}
