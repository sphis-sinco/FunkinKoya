package frontend.play.characters.parents;

import backend.AssetPaths;

class DaddyDearest extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'dad', isPlayer);
	}

	override function get_dadVar():Float
		return 6.1;

	override function initChar()
	{
		frames = AssetPaths.getAnimateAtlas('characters/DADDY_DEAREST', 'characters');

		addFrameLabelAnim('idle', 'idle');
		addSingingAnimations(false, (name, prefix) -> addFrameLabelAnim(name, prefix));
	}

	override function getDataPathPrefix():String
		return 'data/characters/parents/${curCharacter}-';
}
