package koya.frontend.play.characters.gf;

import koya.backend.AssetPaths;

using StringTools;

class GFRegular extends Character
{
	public var gfVersion:String = 'gf';

	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false, ?gfVersion:String = 'gf')
	{
		this.gfVersion = gfVersion;

		super(x, y, gfVersion, isPlayer);
		setCharacter(gfVersion);
		iconChar = 'gf';
	}

	override function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		super.playAnim(AnimName, Force, Reversed, Frame);

		if (gfVersion == 'gf')
		{
			if (AnimName == 'singLEFT') danced = true;
			else if (AnimName == 'singRIGHT') danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN') danced = !danced;
		}
	}

	public function getFrames()
	{
		frames = AssetPaths.getAnimateAtlas('characters/girlfriend-regular', 'characters');
	}

	override function initChar()
	{
		getFrames();

		addIndicesFrameLabelAnim('danceLeft', 'danceBeat', [0, 1, 2, 3, 4]);
		addIndicesFrameLabelAnim('danceRight', 'danceBeat', [5, 6, 7, 8, 9]);
		addFrameLabelAnim('sad', 'sad');

		if (gfVersion == 'gf') addSingingAnimations(false, (name, prefix) -> addFrameLabelAnim(name, prefix));
	}

	override function dance()
	{
		if (!debugMode)
		{
			if (anim.name?.startsWith('hair')) return;

			danced = !danced;

			if (danced) playAnim('danceRight');
			else
				playAnim('danceLeft');
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (anim.name == 'hairFall' && anim.finished) playAnim('danceRight');
	}

	override function getDataPathPrefix():String
		return 'data/characters/gf/${curCharacter}-';
}
