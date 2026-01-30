package frontend.play.characters.gf;

import backend.AssetPaths;

using StringTools;

class GFRegular extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'gf', isPlayer);
	}

	override function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		super.playAnim(AnimName, Force, Reversed, Frame);

		if (AnimName == 'singLEFT')
			danced = true;
		else if (AnimName == 'singRIGHT')
			danced = false;

		if (AnimName == 'singUP' || AnimName == 'singDOWN')
			danced = !danced;
	}

	override function initChar()
	{
		frames = AssetPaths.getAnimateAtlas('characters/girlfriend-regular', 'characters');

		addIndicesPrefixAnim('danceLeft', 'danceBeat', [0, 1, 2, 3, 4]);
		addIndicesPrefixAnim('danceRight', 'danceBeat', [5, 6, 7, 8, 9]);

		addPrefixAnim('sad', 'sad');
	}

	override function dance()
	{
		if (!debugMode)
			if (!animation.curAnim.name.startsWith('hair'))
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');
			}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
			playAnim('danceRight');
	}

	override function getOffsetsPath():String
		return AssetPaths.txt('data/characters/gf/${curCharacter}-offsets', 'characters');
}
