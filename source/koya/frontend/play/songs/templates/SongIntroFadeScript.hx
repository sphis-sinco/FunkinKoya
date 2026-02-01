package koya.frontend.play.songs.templates;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import koya.backend.Conductor;
import flixel.tweens.FlxTween;

class SongIntroFadeScript extends SongClass
{
	public var songObjectsToHide:Array<String> = [];

	override public function new(songObjectsToHide:Array<String>)
	{
		super();

		this.songObjectsToHide = songObjectsToHide;
	}

	override public function preCountdown():Bool
	{
		if (gf != null) gf.alpha = 0;
		if (dad != null) dad.alpha = 0;
		if (boyfriend != null) boyfriend.alpha = 0;

		return true;
	}

	public var dadFade:FlxTween;

	public function dadFadeFunction()
	{
		if (dad != null)
		{
			trace('DAD FADE');
			dadFade = FlxTween.tween(dad, {alpha: 1}, (Conductor.crochet / 1000) * 4,
				{
					ease: FlxEase.sineInOut
				});
			dadFade.manager = PlayState.instance.tweenManager;
		}
	}

	public var bfFade:FlxTween;

	public function boyfriendFadeFunction()
	{
		if (boyfriend != null)
		{
			trace('BOYFRIEND FADE');
			bfFade = FlxTween.tween(boyfriend, {alpha: 1}, (Conductor.crochet / 1000) * 4,
				{
					ease: FlxEase.sineInOut
				});
			bfFade.manager = PlayState.instance.tweenManager;
		}
	}

	public function forStageObject(thendo:Dynamic->Void)
	{
		for (OBJECT_NAME in songObjectsToHide)
			if (PlayState.instance.currentStage.getThing(OBJECT_NAME) != null)
			{
				var invalidTypes:Array<Dynamic> = [String, Int, Float, Enum];

				var dontdo = false;

				try
				{
					for (type in invalidTypes)
						if (Std.isOfType(type, PlayState.instance.currentStage.getThing(OBJECT_NAME))) dontdo = true;
				}
				catch (e)
				{
					trace(e.message);
				}

				if (!dontdo) thendo(PlayState.instance.currentStage.getThing(OBJECT_NAME));
			}
	}

	public var finishBeat:Int = 0;

	override public function beatHit(beat:Int)
	{
		if (beat == finishBeat) finishedIntro();
	}

	public var endingFlashBeats:Int = 1;

	public function finishedIntro()
	{
		if (gf != null) gf.alpha = 1;
		if (boyfriend != null) boyfriend.alpha = 1;
		if (dad != null) dad.alpha = 1;

		dadFade.destroy();
		bfFade.destroy();

		FlxG.camera.flash(FlxColor.WHITE, (Conductor.crochet / 1000) * endingFlashBeats);
	}

	override function pause()
	{
		super.pause();

		if (bfFade != null) bfFade.active = false;
		if (dadFade != null) dadFade.active = false;
	}

	override function unpause()
	{
		super.unpause();

		if (bfFade != null) bfFade.active = true;
		if (dadFade != null) dadFade.active = true;
	}

	public function forcedBFFade()
	{
		// trace('i wanna fade hmmm');
		if (PlayState.instance.health <= 0 && (!bfFade?.active || bfFade == null) && boyfriend.alpha < 1) boyfriendFadeFunction();
	}

	override function noteMiss(direction:Int)
	{
		super.noteMiss(direction);

		forcedBFFade();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		@:privateAccess
		if (PlayState.instance.controls.RESET) {
			PlayState.instance.health = -10;
			forcedBFFade();
		}
	}
}
