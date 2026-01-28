package;

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
	public var versionText:FlxText;

	override public function create():Void
	{
		PlayerSettings.init();

		super.create();

		FlxG.save.bind('koya', 'Macohi');

		Highscore.load();

		Application.current.window.title = Constants.WINDOW_TITLE;

		startIntro();
	}

	function startIntro()
	{
		FlxG.mouse.visible = false;

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.music('title'), 0.7);
			Conductor.changeBPM(140);
		}

		if (!initialized)
		{
			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), null,
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), null,
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			FlxG.sound.music.fadeIn(4, 0, 0.7);

			initialized = true;
		}

		var bg = new FlxSprite().loadGraphic(AssetPaths.image('stageback'));
		bg.screenCenter();
		add(bg);

		logo = new FlxSprite();
		logo.frames = AssetPaths.fromSparrow('logoBumpin');
		logo.animation.addByPrefix('bump', 'logoBumpin', 24, false);
		add(logo);
		logo.screenCenter();

		FlxTween.tween(logo, {y: logo.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});

		versionText = new FlxText(9, FlxG.height - (18 + 9), 0, Constants.VERSION, 16);
		add(versionText);
	}

	override function beatHit()
	{
		super.beatHit();

		logo.animation.play('bump');
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}
}
