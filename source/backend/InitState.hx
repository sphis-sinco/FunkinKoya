package backend;

import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import backend.controls.PlayerSettings;
import lime.app.Application;
import flixel.FlxSprite;
import flixel.util.typeLimit.NextState;
import flixel.FlxG;
import frontend.web.TouchHere;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		FlxSprite.defaultAntialiasing = true;

		PlayerSettings.init();
		FlxG.save.bind('koya', 'Macohi');
		Highscore.load();

		Application.current.window.title = Constants.WINDOW_TITLE;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), null,
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), null,
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		var startingState:NextState = () -> new frontend.TitleState();
		#if web
		startingState = () -> new TouchHere();
		#end

		FlxG.switchState(startingState);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
