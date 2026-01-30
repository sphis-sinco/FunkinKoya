package frontend.play;

import frontend.play.characters.CharacterGetter;
import frontend.play.characters.Character;
import frontend.freeplay.FreeplayState;
import backend.*;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
	var character:Character;
	var camFollow:FlxObject;

	var stageSuffix:String = "";

	public function new(x:Float, y:Float)
	{
		var stageSuffix = PlayState.instance.currentStage.getGameoverStageSuffix();
		super();

		Conductor.songPosition = 0;

		character = PlayState.instance.currentStage.getGameoverCharacter();
		
		if (PlayState.instance.currentStage.boyfriend != null)
			character.setPosition(PlayState.instance.currentStage.boyfriend.x, PlayState.instance.currentStage.boyfriend.y);
		else
			character.screenCenter();

		add(character);

		camFollow = new FlxObject(character.getGraphicMidpoint().x, character.getGraphicMidpoint().y, 1, 1);
		add(camFollow);

		FlxG.sound.play(AssetPaths.sound('fnf_loss_sfx$stageSuffix'));
		Conductor.changeBPM(100);

		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		character.playAnim('firstDeath');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			endBullshit();

		if (controls.BACK)
		{
			FlxG.sound.music.stop();

			FlxG.sound.play(AssetPaths.sound('cancelMenu', 'ui'));
			FlxG.switchState(() -> new FreeplayState());
		}

		if (character.animation.curAnim.name == 'firstDeath' && character.animation.curAnim.curFrame == 12)
			FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (character.animation.curAnim.name == 'firstDeath' && character.animation.curAnim.finished)
			FlxG.sound.playMusic(AssetPaths.music('gameOver$stageSuffix'));

		if (FlxG.sound.music.playing)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			character.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(AssetPaths.music('gameOverEnd$stageSuffix'));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
				{
					FlxG.switchState(() -> new PlayState());
				});
			});
		}
	}
}
