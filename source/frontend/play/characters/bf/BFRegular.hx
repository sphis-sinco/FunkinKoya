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
		frames = AssetPaths.fromSparrow('characters/boyfriend', 'characters');

		addPrefixAnim('idle', 'BF anim idle');

		var directions = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

		for (dir in directions)
		{
			addPrefixAnim('sing${dir.toUpperCase()}', 'BF anim ${dir.toLowerCase()}');
			addPrefixAnim('sing${dir.toUpperCase()}miss', 'BF anim miss ${dir.toLowerCase()}');
		}

		flipX = true;
	}

	override function getOffsetsPath():String
		return AssetPaths.txt('data/characters/bf/${curCharacter}-offsets', 'characters');
}
