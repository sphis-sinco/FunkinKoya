package frontend.play.characters;

import lime.utils.Assets;
import backend.Conductor;
import backend.AssetPaths;
import flixel.FlxSprite;

using StringTools;

class Character extends FlxSprite
{
	public var stunned:Bool = false;

	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		getOffsets();
		initChar();

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public var dadVar(get, never):Float;

	function get_dadVar():Float
	{
		return 4;
	}

	override function update(elapsed:Float)
	{
		if (isPlayer)
		{
			if (!debugMode)
			{
				if (animation.name.startsWith('sing'))
					holdTimer += elapsed;
				else
					holdTimer = 0;

				if (animation.finished)
				{
					if (animation.name.endsWith('miss'))
						playAnim('idle', true, false, 10);

					if (animation.name == 'firstDeath')
						playAnim('deathLoop');
				}
			}
		}
		else
		{
			if (animation.name.startsWith('sing'))
				holdTimer += elapsed;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		super.update(elapsed);
	}

	public var danced:Bool = false;

	public function dance()
	{
		if (!debugMode)
			playAnim('idle');
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(animation.name);
		if (animOffsets.exists(animation.name))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
		animOffsets[name] = [x, y];

	public function initChar()
	{
		switch (curCharacter) {}
	}

	public function getOffsetsPath():String
		return AssetPaths.txt('data/characters/$curCharacter/offsets', 'characters');

	public function getOffsets()
	{
		var offsetPath = getOffsetsPath();

		if (!Assets.exists(offsetPath))
			return;

		trace('found offset: $offsetPath');
		var offsetfile = Assets.getText(offsetPath).split('\n');

		for (line in offsetfile)
		{
			var splitLine = line.split(' ; ');

			var anim = splitLine[0] ?? null;
			var x = splitLine[1] ?? '0';
			var y = splitLine[2] ?? '0';

			if (anim != null)
				addOffset(anim, Std.parseFloat(x), Std.parseFloat(y));
		}
	}
}
