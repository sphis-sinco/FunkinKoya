package koya.frontend.scenes.play.characters.unogchars;

import koya.backend.AssetPaths;

class Spooky extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'spooky', isPlayer);
	}

	override function initChar()
	{
		frames = AssetPaths.getAnimateAtlas('characters/spookeez', 'characters');

		addFrameLabelAnim('idle', 'idle');
		addSingingAnimations(false, (name, prefix) -> addFrameLabelAnim(name, prefix));
		addFrameLabelAnim('cheer', 'cheer');
	}
}
