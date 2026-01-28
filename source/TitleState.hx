package;

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

	override public function create():Void
	{
		PlayerSettings.init();

		super.create();

		FlxG.save.bind('koya', 'Macohi');

		Highscore.load();

		startIntro();
	}

	function startIntro()
	{
		FlxG.mouse.visible = false;

		if (!initialized)
		{
			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), null,
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), null,
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			initialized = true;
		}

		if (FlxG.sound.music == null)
		{
			FlxG.sound.playMusic(AssetPaths.music('title'), 0.7);

			// this is for freakyMenu...
			// Conductor.changeBPM(102);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		var bg = new FlxSprite().loadGraphic(AssetPaths.image('stageback'));
		bg.screenCenter();
		add(bg);

		logo = new FlxSprite();
		logo.frames = AssetPaths.fromSparrow('logoBumpin');
		logo.animation.addByPrefix('bump', 'logoBumpin');
		add(logo);
		logo.screenCenter();

		FlxTween.tween(logo, {y: logo.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
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
