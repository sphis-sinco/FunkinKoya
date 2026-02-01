package koya.frontend.play.characters.ogchars;

import koya.backend.AssetPaths;

class Monster extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'monster', isPlayer);
	}

	override function initChar()
	{
		frames = AssetPaths.getAnimateAtlas('characters/monster-regular', 'characters');

		addFrameLabelAnim('idle', 'idle');
		addSingingAnimations(false, (name, prefix) -> addFrameLabelAnim(name, prefix));
	}
}
