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
		// GIRLFRIEND CODE
		frames = AssetPaths.fromSparrow('GF_assets');
		animation.addByPrefix('cheer', 'GF Cheer', 24, false);
		animation.addByPrefix('singLEFT', 'GF left note', 24, false);
		animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
		animation.addByPrefix('singUP', 'GF Up Note', 24, false);
		animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
		animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
		animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
		animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
		animation.addByPrefix('scared', 'GF FEAR', 24);

		addOffset('cheer');
		addOffset('sad', -2, -2);
		addOffset('danceLeft', 0, -9);
		addOffset('danceRight', 0, -9);

		addOffset("singUP", 0, 4);
		addOffset("singRIGHT", 0, -20);
		addOffset("singLEFT", 0, -19);
		addOffset("singDOWN", 0, -20);
		addOffset('hairBlow', 45, -8);
		addOffset('hairFall', 0, -9);

		addOffset('scared', -2, -17);

		playAnim('danceRight');
	}

	override function dance()
	{
		if (!debugMode)
		{
			if (!animation.curAnim.name.startsWith('hair'))
			{
				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
			playAnim('danceRight');
	}
}
