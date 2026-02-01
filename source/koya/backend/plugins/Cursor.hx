package koya.backend.plugins;

import flixel.FlxG;
import flixel.FlxBasic;

class Cursor extends FlxBasic
{
	public static var cursorVisible:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.visible != cursorVisible) FlxG.mouse.visible = cursorVisible;
	}
}
