package koya.backend;

import koya.frontend.mainmenu.MainMenuState;
import koya.frontend.TitleState;
import koya.frontend.play.editors.ChartingState;
import koya.frontend.freeplay.FreeplayState;
import koya.backend.tasks.ResaveAllSongs;
import koya.backend.save.Save;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import koya.backend.controls.PlayerSettings;
import lime.app.Application;
import flixel.FlxSprite;
import flixel.util.typeLimit.NextState;
import flixel.FlxG;
import koya.frontend.web.TouchHere;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		FlxSprite.defaultAntialiasing = true;

		Save.init();

		Application.current.window.title = Constants.WINDOW_TITLE;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), null,
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), null,
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		var startingState:NextState = getStartingState();

		#if web
		startingState = () -> new TouchHere();
		#end

		#if TASK_RESAVE_ALL_SONGS
		ResaveAllSongs.run();
		#end

		FlxG.signals.postUpdate.add(function() {
			if (FlxG.keys.pressed.F3 && FlxG.keys.pressed.C)
			{
				throw 'F3 + C';
			}
		});

		FlxG.switchState(startingState);
	}

	public static function getStartingState():NextState
	{
		#if FREEPLAY
		return () -> new FreeplayState();
		#end

		#if CHARTING
		return () -> new ChartingState();
		#end

		#if MAINMENU
		return () -> new MainMenuState();
		#end

		return () -> new TitleState();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
