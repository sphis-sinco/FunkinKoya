package koya.frontend;

import koya.frontend.mainmenu.MainMenuState;
import koya.frontend.play.stages.basegame.MainStage;
import koya.frontend.freeplay.FreeplayState;
import koya.frontend.play.PlayState;
import koya.backend.Highscore;
import koya.backend.controls.PlayerSettings;
import koya.backend.Conductor;
import lime.app.Application;
import koya.backend.Constants;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	public var logo:FlxSprite;
	public var logoDRK:FlxSprite;

	public var versionText:FlxText;

	public var transitioning:Bool = false;

	override public function create():Void
	{
		super.create();

		startIntro();
	}

	var playingTitle:Bool = false;

	function startIntro()
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
		add(mainStage.stageBack);

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

		versionText = new FlxText(4, FlxG.height - (18 + 4), 0, Constants.VERSION, 16);
		versionText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(versionText);
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
				FlxG.camera.flash(FlxColor.WHITE, Conductor.crochet / 1000 * 4, finish);
			}
			else
			{
				FlxG.sound.play(AssetPaths.sound('confirmMenu', 'ui'));
				FlxG.camera.flash(FlxColor.WHITE, 1, finish);
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
