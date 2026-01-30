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
		frames = AssetPaths.fromSparrow('characters/DADDY_DEAREST', 'characters');
		
		addPrefixAnim('idle', 'Dad idle dance', 24);
		addPrefixAnim('singUP', 'Dad Sing Note UP', 24);
		addPrefixAnim('singRIGHT', 'Dad Sing Note RIGHT', 24);
		addPrefixAnim('singDOWN', 'Dad Sing Note DOWN', 24);
		addPrefixAnim('singLEFT', 'Dad Sing Note LEFT', 24);

		playAnim('idle');
	}

	override function getAnimationOffsetsPath():String
		return AssetPaths.txt('data/characters/parents/${curCharacter}-anim_offsets', 'characters');
}
