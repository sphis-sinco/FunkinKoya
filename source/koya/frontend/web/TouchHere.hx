package koya.frontend.web;

import koya.backend.plugins.Cursor;
import koya.backend.InitState;
import flixel.util.FlxColor;
import flixel.FlxG;
import koya.backend.AssetPaths;
import flixel.FlxSprite;

class TouchHere extends MusicBeatState
{
	public var button:FlxSprite;

	override function create()
	{
		super.create();

		add(new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString('#121317')));
		add(new FlxSprite(320, -80).loadGraphic(AssetPaths.image('touch_bg', 'touchhere')));

		button = new FlxSprite();
		button.frames = AssetPaths.fromSparrow('touch_button', 'touchhere');
		button.animation.addByPrefix('idle', 'button idle');
		button.animation.addByPrefix('overlap', 'button overlap');
		add(button);

		button.screenCenter();

		Cursor.cursorVisible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.overlaps(button))
		{
			if (button.animation.name != 'overlap') button.animation.play('overlap');

			if (FlxG.mouse.justPressed) FlxG.switchState(InitState.getStartingState());
		}
		else if (button.animation.name != 'idle') button.animation.play('idle');
	}
}
