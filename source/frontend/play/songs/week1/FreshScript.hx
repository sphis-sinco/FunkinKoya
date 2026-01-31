package frontend.play.songs.week1;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import backend.Conductor;
import flixel.tweens.FlxTween;
import frontend.play.characters.Character;

class FreshScript extends SongClass
{
	public var dad(get, never):Character;
	public var boyfriend(get, never):Character;
	public var gf(get, never):Character;

	public var stageBack(get, never):FunkinSprite;
	public var stageFloor(get, never):FunkinSprite;

	function get_dad():Character
		return PlayState.instance.currentStage.dad;

	function get_boyfriend():Character
		return PlayState.instance.currentStage.boyfriend;

	function get_gf():Character
		return PlayState.instance.currentStage.gf;

	function get_stageBack():FunkinSprite
		return cast PlayState.instance.currentStage?.getThing('stageBack');

	function get_stageFloor():FunkinSprite
		return cast PlayState.instance.currentStage?.getThing('stageFloor');

	override public function countdownTick(swagCounter:Int)
	{
		if (swagCounter == 0)
		{
			stageBack.alpha = 0;
			stageFloor.alpha = 0;
			gf.alpha = 0;

			dad.alpha = 0;
			boyfriend.alpha = 0;
		}

		if (swagCounter == 4)
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
	}

	public var dadFade:FlxTween;
	public var bfFade:FlxTween;

	override public function beatHit(beat:Int)
	{
		switch (beat)
		{
			case 4:
				if (boyfriend != null)
				{
					trace('BOYFRIEND FADE');
					bfFade = FlxTween.tween(boyfriend, {alpha: 1}, (Conductor.crochet / 1000) * 4,
						{
							ease: FlxEase.sineInOut
						});
					bfFade.manager = PlayState.instance.tweenManager;
				}
			case 16:
				stageBack.alpha = 1;
				stageFloor.alpha = 1;
				gf.alpha = 1;
				boyfriend.alpha = 1;
				dad.alpha = 1;

				dadFade.destroy();
				bfFade.destroy();

				FlxG.camera.flash(FlxColor.WHITE, (Conductor.crochet / 1000) * 1);

				PlayState.instance.camZooming = true;
				PlayState.instance.gfSpeed = 2;
			case 48, 112:
				PlayState.instance.gfSpeed = 1;
			case 80:
				PlayState.instance.gfSpeed = 2;
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
