package frontend.play.characters.bf;

import backend.AssetPaths;

class BFRegular extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'bf', isPlayer);
	}

	override function initChar()
	{
		frames = AssetPaths.getAnimateAtlas('characters/boyfriend-regular', 'characters');

		addFrameLabelAnim('idle', 'idle');

		addSingingAnimations(true, (name, prefix) -> addFrameLabelAnim(name, prefix));

		addFrameLabelAnim('firstDeath', 'firstDeath');
		addFrameLabelAnim('deathLoop', 'deathLoop', 24, true);
		addFrameLabelAnim('deathConfirm', 'deathConfirm');

		flipX = true;
	}

	override function getDataPathPrefix():String
		return 'data/characters/bf/${curCharacter}-';
}
