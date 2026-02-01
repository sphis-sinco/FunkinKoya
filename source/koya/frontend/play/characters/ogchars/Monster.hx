package koya.frontend.play.characters.ogchars;

import flixel.FlxG;
import koya.backend.AssetPaths;

class Monster extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'monster', isPlayer);
		iconChar = 'retsnom';
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

		switch(PlayState.SONG_DIFFICULTY)
		{
			case EASY: division = 32;
			case NORMAL: division = 8;
			case HARD: division = 4;
		}

		if (PlayState.instance.health > 0.1) PlayState.instance.health -= FlxG.random.float(1 / 1000, 0.25) / division;
	}
}
