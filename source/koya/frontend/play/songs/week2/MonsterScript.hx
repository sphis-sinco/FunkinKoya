package koya.frontend.play.songs.week2;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import koya.backend.Conductor;
import flixel.tweens.FlxTween;
import koya.frontend.play.characters.Character;

class MonsterScript extends SongClass
{
	public var dad(get, never):Character;
	public var boyfriend(get, never):Character;
	public var gf(get, never):Character;

	public var halloweenBack(get, never):FunkinSprite;
	public var stairs(get, never):FunkinSprite;

	function get_dad():Character
		return PlayState.instance.currentStage.dad;

	function get_boyfriend():Character
		return PlayState.instance.currentStage.boyfriend;

	function get_gf():Character
		return PlayState.instance.currentStage.gf;

	function get_halloweenBack():FunkinSprite
		return cast PlayState.instance.currentStage?.getThing('halloweenBack');

	function get_stairs():FunkinSprite
		return cast PlayState.instance.currentStage?.getThing('stairs');

	override public function countdownTick(swagCounter:Int)
	{
		if (swagCounter == 0)
		{
			halloweenBack.alpha = 0;
			stairs.alpha = 0;
			gf.alpha = 0;

			dad.alpha = 0;
			boyfriend.alpha = 0;
		}
	}

	public var dadFade:FlxTween;
	public var bfFade:FlxTween;

	override public function beatHit(beat:Int)
	{
		switch (beat)
		{
			case 4:
				if (dad != null)
				{
					trace('DAD FADE');
					dadFade = FlxTween.tween(dad, {alpha: 1}, (Conductor.crochet / 1000) * 4,
						{
							ease: FlxEase.sineInOut
						});
					dadFade.manager = PlayState.instance.tweenManager;
				}
				
			case 12:
				if (boyfriend != null)
				{
					trace('BOYFRIEND FADE');
					bfFade = FlxTween.tween(boyfriend, {alpha: 1}, (Conductor.crochet / 1000) * 4,
						{
							ease: FlxEase.sineInOut
						});
					bfFade.manager = PlayState.instance.tweenManager;
				}

			case 20:
				halloweenBack.alpha = 1;
				stairs.alpha = 1;
				gf.alpha = 1;
				boyfriend.alpha = 1;
				dad.alpha = 1;

				dadFade.destroy();
				bfFade.destroy();

				FlxG.camera.flash(FlxColor.WHITE, (Conductor.crochet / 1000) * 1);
		}
	}

	override public function moveCamera(bf:Bool):Bool
	{
		if (PlayState.instance.curBeat < 16) return false;

		return true;
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
}
