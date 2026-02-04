package koya.frontend.scenes.play.songs.week1;

import flixel.tweens.FlxEase;
import koya.backend.Conductor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class TutorialScript extends SongClass
{
	override function opNoteHit(note:Note):Bool {
		PlayState.instance.camZooming = false;

		return super.opNoteHit(note);
	}

	override public function moveCamera(bf:Bool):Bool
	{
		if (!bf) FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		else
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});

		return super.moveCamera(bf);
	}
}
