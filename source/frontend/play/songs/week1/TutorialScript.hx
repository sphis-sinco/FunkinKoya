package frontend.play.songs.week1;

import flixel.tweens.FlxEase;
import backend.Conductor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class TutorialScript extends SongClass
{
	override public function moveCamera(bf:Bool):Bool
	{
		if (!bf) FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		else
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});

		return super.moveCamera(bf);
	}
}
