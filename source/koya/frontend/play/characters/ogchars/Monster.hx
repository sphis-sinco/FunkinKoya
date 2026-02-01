package koya.frontend.play.characters.ogchars;

import flixel.util.FlxColor;
import flixel.FlxG;
import koya.backend.AssetPaths;

class Monster extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'monster', isPlayer);
		iconChar = 'retsnom';

		if (!isPlayer && PlayState.instance != null)
		{
			PlayState.instance.healthBar_emptyColor = FlxColor.fromString('#CC9999');
			PlayState.instance.healthBar_fillColor = PlayState.instance.healthBar_emptyColor;
		}
	}

	override function initChar()
	{
		frames = AssetPaths.getAnimateAtlas('characters/monster-regular', 'characters');

		addFrameLabelAnim('idle', 'idle');
		addSingingAnimations(false, (name, prefix) -> addFrameLabelAnim(name, prefix));
	}

	override function onNoteHit(note:Note)
	{
		super.onNoteHit(note);

		var division:Float = 10;
		var minHealth:Float = 0.1;

		switch (PlayState.SONG_DIFFICULTY)
		{
			case EASY:
				division = 32;
				minHealth = 1.5;
			case NORMAL:
				division = 8;
				minHealth = 0.5;
			case HARD:
				division = 4;
				minHealth = 0.1;
		}

		if (!isPlayer) if (PlayState.instance.health > minHealth) PlayState.instance.health -= FlxG.random.float(1 / 1000, 0.25) / division;
	}
}
