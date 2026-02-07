package koya.frontend.scenes.play.scenes;

import koya.backend.save.Save;
import koya.backend.Highscore;
import koya.backend.AssetPaths;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
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
	public var rankSpr:FunkinSprite;

	public var resultsCam:FlxCamera;

	override function create()
	{
		super.create();

		var rank:Rank = PlayState.global_resultsData.grade();
		var percent:Int = Std.int(PlayState.global_resultsData.gradePercent() * 100);
		trace(rank + ' ($percent%)');

		if (!PlayState.IS_STORYMODE) Highscore.saveRank(PlayState.instance.curSong.toLowerCase(), rank, PlayState.SONG_DIFFICULTY);
		else
			Highscore.saveRank(PlayState.STORYMODE_WEEK, rank, PlayState.SONG_DIFFICULTY);

		back = new FunkinSprite();
		back.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString('#FFA7E5'));

		rankSpr = new FunkinSprite();
		rankSpr.frames = AssetPaths.fromSparrow('results/rank_${rank.toLowerCase()}', 'ui');

		rankSpr.addPrefixAnim('rank', rank.toLowerCase(), 24, true);
		rankSpr.playAnim('rank');

		rankSpr.updateHitbox();
		rankSpr.screenCenter();

		rankSpr.visible = false;

		resultsCam = new FlxCamera();

		back.cameras = [resultsCam];
		rankSpr.cameras = [resultsCam];

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

		var backFadeInTime:Float = (Conductor.crochet / 1000) * 4;

		PlayState.instance.add(back);
		PlayState.instance.add(rankSpr);
		FlxTween.tween(back, {y: 0, alpha: 1}, backFadeInTime,
			{
				ease: FlxEase.quadInOut,
				onComplete: t -> {}
			});

		FlxTimer.wait(backFadeInTime + 0.25, function() {
			var comboNum = new ComboNumbers(Std.int(percent), FlxG.width / 2.2, (cn) -> {
				remove(cn);
				cn.destroy();

				FlxTimer.wait(1, () -> {
					FlxG.sound.play(AssetPaths.sound('confirmMenu', 'ui'));

					if (Save.preferences.get().flashingLights) resultsCam.flash(FlxColor.WHITE, .2);

					rankSpr.playAnim('rank');
					rankSpr.visible = true;

					FlxTimer.wait(1, () -> {
						FlxG.switchState(nextState);
					});
				});
			});

			for (numScore in comboNum.members)
			{
				numScore.visible = false;
				numScore.screenCenter();

				if (comboNum.comboLength > 1)
				{
					numScore.x -= (43 * comboNum.comboLength / 2) - 90;
					numScore.x += (43 * numScore.ID) - 90;
				}

				FlxTimer.wait(.1 * numScore.ID, () -> {
					FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
					numScore.visible = true;
				});
			}
			comboNum.cameras = [resultsCam];
			add(comboNum);
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT && back.alpha == 1)
		{
			FlxG.sound.play(AssetPaths.sound('cancelMenu', 'ui'));
			FlxG.switchState(nextState);
		}
	}
}
