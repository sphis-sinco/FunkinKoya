package frontend.play.songs.week1;

import flixel.tweens.FlxEase;
import backend.Conductor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class TutorialScript extends SongClass
{
	public function moveCamera(args:Map<String, Dynamic>)
	{
		var bf:Bool = args.get('bf');
		if (!bf)
			FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		else
			FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}
}
