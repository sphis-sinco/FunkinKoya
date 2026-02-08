package koya.frontend.scenes;

import flixel.util.FlxTimer;
import koya.backend.save.Save;
import koya.frontend.scenes.menustates.MainMenuState;
import koya.frontend.scenes.play.stages.basegame.MainStage;
import koya.backend.Conductor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	public var logo:FlxSprite;
	public var logoDRK:FlxSprite;

	public var transitioning:Bool = false;

	override public function create():Void
	{
		super.create();

		begin();
	}

	var playingTitle:Bool = false;

	function begin()
	{
		if (!initialized)
		{
			if (FlxG.sound.music == null || !FlxG.sound.music.playing)
			{
				// no onComplete function? wtf
				FlxG.sound.playMusic(AssetPaths.music('title'), 0.7, false, null);
				playingTitle = true;
				Conductor.changeBPM(140);
				FlxG.sound.music.fadeIn(Conductor.crochet / 1000 * 4, 0, 0.7);
			}

			initialized = true;
		}

		var mainStage = new MainStage(null, true);
		add(cast mainStage.getThing('stageBack'));

		logo = new FlxSprite();
		logo.frames = AssetPaths.fromSparrow('logoBumpin');
		logo.animation.addByPrefix('bump', 'logoBumpin', 24, false);
		logo.screenCenter();

		logoDRK = logo.clone();
		logoDRK.screenCenter();
		logoDRK.color = FlxColor.BLACK;
		logoDRK.alpha = .5;
		add(logoDRK);

		add(logo);

		FlxTween.tween(logo, {y: logo.y + 100}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(logoDRK, {y: logo.y + 100}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: .1});
	}

	override function beatHit()
	{
		super.beatHit();

		logo.animation.play('bump');
	}

	override function stepHit()
	{
		super.stepHit();

		if (curStep % 5 == 0) logoDRK.animation.play('bump');
	}

	override function update(elapsed:Float)
	{
		if ((FlxG.sound.music == null || !FlxG.sound.music.playing) && !transitioning)
		{
			FlxG.sound.playMusic(AssetPaths.music('freakyMenu'), 0.7, false);
			Conductor.changeBPM(102);
			playingTitle = false;
		}

		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;

		if (controls.ACCEPT && !transitioning)
		{
			transitioning = true;
			if (playingTitle)
			{
				FlxG.sound.music.stop();

				FlxTween.cancelTweensOf(logo);
				FlxTween.cancelTweensOf(logoDRK);

				var prevLogoY = logo.y;
				logo.screenCenter(Y);
				var centerLogoY = logo.y;
				logo.y = prevLogoY;

				FlxTween.tween(logo, {y: centerLogoY}, Conductor.crochet / 1000 * 2, {ease: FlxEase.quadIn});
				FlxTween.tween(logoDRK, {y: centerLogoY}, Conductor.crochet / 1000 * 2, {ease: FlxEase.quadIn, startDelay: .1});

				FlxG.sound.play(AssetPaths.music('titleShoot'));
				
				if (Save.preferences.get().flashingLights) FlxG.camera.flash(FlxColor.WHITE, Conductor.crochet / 1000 * 4, finish);
				if (!Save.preferences.get().flashingLights) FlxTimer.wait(Conductor.crochet / 1000 * 4, finish);
			}
			else
			{
				FlxG.sound.play(AssetPaths.sound('confirmMenu', 'ui'));

				if (Save.preferences.get().flashingLights) FlxG.camera.flash(FlxColor.WHITE, 1, finish);
				if (!Save.preferences.get().flashingLights) FlxTimer.wait(Conductor.crochet / 1000 * 4, finish);
			}
		}

		super.update(elapsed);
	}

	public function finish()
	{
		FlxTween.cancelTweensOf(logo);
		FlxTween.cancelTweensOf(logoDRK);

		FlxTween.tween(logo, {y: -(logo.height * 4)}, 1.2, {ease: (playingTitle) ? FlxEase.quadOut : FlxEase.quadInOut});
		FlxTween.tween(logoDRK, {y: -(logo.height * 4)}, 1.2, {ease: (playingTitle) ? FlxEase.quadOut : FlxEase.quadInOut, startDelay: .1});

		FlxG.switchState(() -> new MainMenuState());
	}
}
