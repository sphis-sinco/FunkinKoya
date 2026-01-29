package frontend;

import frontend.freeplay.FreeplayState;
import frontend.play.PlayState;
import backend.Highscore;
import backend.controls.PlayerSettings;
import backend.Conductor;
import lime.app.Application;
import backend.Constants;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import backend.AssetPaths;
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

	function startIntro()
	{
		FlxG.mouse.visible = false;

		if (!initialized)
		{
			if (FlxG.sound.music == null || !FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(AssetPaths.music('title'), 0.7, false);
				Conductor.changeBPM(140);
			}

			FlxG.sound.music.fadeIn(Conductor.crochet / 1000 * 4, 0, 0.7);

			initialized = true;
		}

		var bg = new FlxSprite().loadGraphic(AssetPaths.image('stageback'));
		bg.screenCenter();
		add(bg);

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

		versionText = new FlxText(2, FlxG.height - (18 + 2), 0, Constants.VERSION, 16);
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

		if (curStep % 5 == 0)
			logoDRK.animation.play('bump');
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (controls.ACCEPT && !transitioning)
		{
			transitioning = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(AssetPaths.music('titleShoot'), 1.0, false, null, true, function() {});

			FlxG.camera.flash(FlxColor.WHITE, Conductor.crochet / 1000 * 4, function()
			{
				FlxG.switchState(() -> new FreeplayState());
			});
		}

		super.update(elapsed);
	}
}
