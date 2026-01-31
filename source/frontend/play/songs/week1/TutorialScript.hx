package frontend.play.songs.week1;

import flixel.tweens.FlxEase;
import backend.Conductor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class TutorialScript extends SongClass
{
	public function moveCamera(bf:Bool)
	{
		if (!bf)
		{
			if (PlayState.instance.curSong == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
		else
		{
			if (PlayState.instance.curSong == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
	}
}
