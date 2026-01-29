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
		frames = AssetPaths.fromSparrow('DADDY_DEAREST');
		animation.addByPrefix('idle', 'Dad idle dance', 24);
		animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
		animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
		animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
		animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

		playAnim('idle');
	}

	override function getOffsetsPath():String
		return AssetPaths.txt('data/characters/parents/${curCharacter}-offsets', 'characters');
}
