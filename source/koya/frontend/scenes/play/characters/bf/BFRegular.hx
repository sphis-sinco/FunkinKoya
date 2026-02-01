package koya.frontend.scenes.play.characters.bf;

import koya.backend.AssetPaths;

class BFRegular extends Character
{
	public var bfVersion:String = 'bf';

	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false, ?bfVersion:String = '')
	{
		this.bfVersion = bfVersion;

		super(x, y, bfVersion, isPlayer);
		setCharacter(bfVersion);
		iconChar = 'bf';
	}

	public function getFrames()
	{
		frames = AssetPaths.getAnimateAtlas('characters/boyfriend-regular', 'characters');
	}

	override function initChar()
	{
		getFrames();

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
