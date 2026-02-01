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

		if (PlayState.instance.health > 0.1) PlayState.instance.health -= FlxG.random.float(0, 1) / 10;
	}
}
