package koya.frontend.play.songs.week2;

import koya.frontend.play.songs.templates.SongIntroFadeScript;
import koya.frontend.shaders.AdjustColorShader;

class MonsterScript extends SongIntroFadeScript
{
	override public function new()
	{
		super(['halloweenBack', 'stairs']);
		endingFlashBeats = 71;
	}

	public var startShader:AdjustColorShader;

	override public function preCountdown():Bool
	{
		startShader = new AdjustColorShader();

		startShader.saturation = -62;
		startShader.hue = -24;
		startShader.contrast = -32;
		startShader.brightness = -28;

		if (boyfriend != null) boyfriend.shader = startShader;
		if (dad != null) dad.shader = startShader;
		if (gf != null) gf.shader = startShader;

		forStageObject((obj) -> {
			var funkSpr:FunkinSprite = cast obj;

			if (funkSpr != null)
			{
				funkSpr.alpha = 0;
				funkSpr.shader = startShader;
			}
		});

		return super.preCountdown();
	}

	override public function beatHit(beat:Int)
	{
		switch (beat)
		{
			case 4:
				dadFadeFunction();
			case 12:
				boyfriendFadeFunction();
		}

		super.beatHit(beat);
	}

	override function finishedIntro()
	{
		super.finishedIntro();

		forStageObject((obj) -> {
			var funkSpr:FunkinSprite = cast obj;

			if (funkSpr != null) funkSpr.alpha = 1;
		});
	}
}
