package backend;

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

		FlxSprite.defaultAntialiasing = false;

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
