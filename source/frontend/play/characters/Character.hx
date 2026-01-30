package frontend.play.characters;

import flixel.util.typeLimit.OneOfTwo;
import animate.FlxAnimate;
import lime.utils.Assets;
import backend.Conductor;
import backend.AssetPaths;
import flixel.FlxSprite;

using StringTools;

class Character extends FlxAnimate
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
				var oldRight = anim.getByName('singRIGHT').frames;
				anim.getByName('singRIGHT').frames = anim.getByName('singLEFT').frames;
				anim.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (anim.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = anim.getByName('singRIGHTmiss').frames;
					anim.getByName('singRIGHTmiss').frames = anim.getByName('singLEFTmiss').frames;
					anim.getByName('singLEFTmiss').frames = oldMiss;
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
				if (anim.name.startsWith('sing'))
					holdTimer += elapsed;
				else
					holdTimer = 0;

				if (anim.finished)
				{
					if (anim.name.endsWith('miss'))
						playAnim('idle', true, false, 10);

					if (anim.name == 'firstDeath')
						playAnim('deathLoop');
				}
			}
		}
		else
		{
			if (anim.name.startsWith('sing'))
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
		anim.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(anim.name);
		if (animOffsets.exists(anim.name))
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

	public function addPrefixAnim(name:String, prefix:String, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByPrefix(name, prefix, fps, looped);

	public function addFrameLabelAnim(name:String, label:String, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByFrameLabel(name, label, fps, looped);

	public function addIndicesPrefixAnim(name:String, prefix:String, indices:Array<Int>, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByIndices(name, prefix, indices, '', fps, looped);

	public function addIndicesFrameLabelAnim(name:String, label:String, indices:Array<Int>, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByFrameLabelIndices(name, label, indices, fps, looped);
}
