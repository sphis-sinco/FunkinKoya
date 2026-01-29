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
		frames = AssetPaths.fromSparrow('BOYFRIEND');
		animation.addByPrefix('idle', 'BF idle dance', 24, false);
		animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
		animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
		animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
		animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
		animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
		animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
		animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
		animation.addByPrefix('hey', 'BF HEY', 24, false);

		animation.addByPrefix('firstDeath', "BF dies", 24, false);
		animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
		animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

		animation.addByPrefix('scared', 'BF idle shaking', 24);

		flipX = true;
	}

	override function getOffsetsPath():String
		return AssetPaths.txt('data/characters/bf/${curCharacter}-offsets', 'characters');
}
