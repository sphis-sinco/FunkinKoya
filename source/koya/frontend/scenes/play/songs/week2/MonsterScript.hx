package koya.frontend.scenes.play.songs.week2;

import flixel.tweens.FlxEase;
import koya.backend.Conductor;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import koya.frontend.scenes.play.songs.templates.SongIntroFadeScript;
import koya.frontend.shaders.AdjustColorShader;

class MonsterScript extends SongIntroFadeScript
{
	override public function new()
	{
		super(['halloweenBack', 'stairs']);
		finishBeat = 72;
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

		FlxG.camera.zoom = 0.4;
		PlayState.instance.camZooming = false;

		return super.preCountdown();
	}

	override function opNoteHit(note:Note):Bool
	{
		if (PlayState.instance.curBeat < finishBeat) PlayState.instance.camZooming = false;

		return super.opNoteHit(note);
	}

	var sceneTween:FlxTween;

	override public function beatHit(beat:Int)
	{
		switch (beat)
		{
			case 4:
				dadFadeFunction();
				sceneTween = FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom}, (Conductor.crochet / 1000) * (finishBeat - beat),
					{
						ease: FlxEase.quadInOut,
					});
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

	override function pause()
	{
		super.pause();

		sceneTween.active = false;
	}

	override function unpause()
	{
		super.unpause();

		sceneTween.active = true;
	}
}
