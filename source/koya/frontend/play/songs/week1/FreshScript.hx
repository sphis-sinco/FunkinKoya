package koya.frontend.play.songs.week1;

import koya.frontend.play.songs.templates.SongIntroFadeScript;

class FreshScript extends SongIntroFadeScript
{
	override public function new()
	{
		super(['stageBack', 'songFloor']);
		finishBeat = 16;
	}

	override function finishedIntro()
	{
		super.finishedIntro();

		forStageObject((obj) -> {
			var funkSpr:FunkinSprite = cast obj;

			if (funkSpr != null) funkSpr.alpha = 1;
		});
	}

	override public function preCountdown():Bool
	{
		forStageObject((obj) -> {
			var funkSpr:FunkinSprite = cast obj;

			if (funkSpr != null) funkSpr.alpha = 0;
		});

		return super.preCountdown();
	}

	override public function countdownTick(swagCounter:Int)
	{
		if (swagCounter == 4) dadFadeFunction();
	}

	override public function beatHit(beat:Int)
	{
		switch (beat)
		{
			case 4:
				boyfriendFadeFunction();
			case 16:
				PlayState.instance.camZooming = true;
				PlayState.instance.gfSpeed = 2;
			case 48, 112:
				PlayState.instance.gfSpeed = 1;
			case 80:
				PlayState.instance.gfSpeed = 2;
		}

		super.beatHit(beat);
	}

	override public function moveCamera(bf:Bool):Bool
	{
		if (PlayState.instance.curBeat < 16) return false;

		return true;
	}
}
