package koya.frontend.scenes.play.characters.unogchars;

import koya.backend.AssetPaths;

class Pico extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'pico', isPlayer);
	}

	override function initChar()
	{
		frames = AssetPaths.getAnimateAtlas('characters/pico', 'characters');

		addFrameLabelAnim('idle', 'idle');
		for (anim in ['left', 'down', 'up', 'right'])
			addFrameLabelAnim('sing${anim.toUpperCase()}', anim);
	}
}
