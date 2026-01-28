package backend;

import flixel.util.typeLimit.NextState;
import flixel.FlxG;
import frontend.web.TouchHere;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		var startingState:NextState = () -> new TitleState();
		#if web
		startingState = () -> new TouchHere();
		#end

		trace('Moving to ${Type.getClassName(cast startingState.createInstance())}');
		FlxG.switchState(startingState);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
