package koya.frontend.scenes.play.characters;

import koya.backend.play.stages.StageProp;
import haxe.Json;
import koya.frontend.scenes.play.stages.StageBGProps;
import haxe.Template;
import flixel.math.FlxPoint;
import flixel.util.typeLimit.OneOfTwo;
import animate.FlxAnimate;
import koya.backend.KoyaAssets;
import koya.backend.Conductor;
import koya.backend.AssetPaths;
import flixel.FlxSprite;

using StringTools;

class Character extends FunkinSprite
{
	public static function getCharacter(char:String, ?isPlayer:Bool, ?x:Float, ?y:Float):Character
		return CharacterGetter.getCharacter(char, isPlayer, x, y);

	public var stunned:Bool = false;

	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var iconChar:String = 'bf';

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		setCharacter(character);
		this.isPlayer = isPlayer;
	}

	public function setCharacter(character:String = 'bf')
	{
		curCharacter = character;
		this.iconChar = character;
	}

	public var flipAnimationsAsPlayer:Bool = true;

	public function loadAssets()
	{
		trace('Loading character: $curCharacter');
		getCharacterOffsets();
		getAnimationOffsets();
		getCameraOffsets();
		initChar();

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for some, since theirs are already in the right place???
			if (flipAnimationsAsPlayer)
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
		return 4;

	override function update(elapsed:Float)
	{
		if (isPlayer)
		{
			if (!debugMode)
			{
				if (anim.name?.startsWith('sing')) holdTimer += elapsed;
				else
					holdTimer = 0;

				if (anim.finished)
				{
					if (anim.name?.endsWith('miss')) playAnim('idle', true, false, 10);

					if (anim.name == 'firstDeath') playAnim('deathLoop');
				}
			}
		}
		else
		{
			if (anim.name?.startsWith('sing')) holdTimer += elapsed;

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
		if (!debugMode) playAnim('idle');
	}

	public var datapathprefix:String = 'data/characters/::curCharacter::/';

	public function getDataPathPrefix():String
		return new Template(datapathprefix).execute(
			{
				curCharacter: curCharacter
			});

	public function getDataPathLibrary():String
		return 'characters';

	public function getCharacterJSON():String
		return AssetPaths.json('characters/$curCharacter', getDataPathLibrary());

	public function getAnimationOffsetsPath():String
		return AssetPaths.txt('${getDataPathPrefix()}anim_offsets', getDataPathLibrary());

	public function getCharacterOffsetsPath():String
		return AssetPaths.txt('${getDataPathPrefix()}character_offsets', getDataPathLibrary());

	public function getCameraOffsetsPath():String
		return AssetPaths.txt('${getDataPathPrefix()}camera_offsets', getDataPathLibrary());

	public function getCharacterOffsets()
	{
		var offsetPath = getCharacterOffsetsPath();

		if (!KoyaAssets.exists(offsetPath)) return;

		trace(' * found character offset file: $offsetPath');
		var offsetfile = KoyaAssets.getText(offsetPath).split('\n');

		generalOffsets = [];
		for (line in offsetfile)
			generalOffsets.push(Std.parseFloat(line ?? '0') ?? 0.0);
	}

	public function cameraMoveToMe() {}

	public function getCameraOffsets()
	{
		var offsetPath = getCameraOffsetsPath();

		if (!KoyaAssets.exists(offsetPath)) return;

		trace(' * found camera offset file: $offsetPath');
		var offsetfile = KoyaAssets.getText(offsetPath).split('\n');

		cameraOffsets = [];
		for (line in offsetfile)
			cameraOffsets.push(Std.parseFloat(line ?? '0') ?? 0.0);
	}

	public function getAnimationOffsets()
	{
		var offsetPath = getAnimationOffsetsPath();

		if (!KoyaAssets.exists(offsetPath)) return;

		trace(' * found animation offset file: $offsetPath');
		var offsetfile = KoyaAssets.getText(offsetPath).split('\n');

		parseAnimationOffsetFile(offsetfile);
	}

	public function addSingingAnimations(includeMiss:Bool = false, addAnimationFunction:(name:String, prefix:String) -> Void)
	{
		var directions = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

		for (dir in directions)
		{
			addAnimationFunction('sing${dir.toUpperCase()}', 'sing${dir.toUpperCase()}');
			if (includeMiss) addAnimationFunction('sing${dir.toUpperCase()}miss', 'sing${dir.toUpperCase()}miss');
		}
	}

	public function getStartingCamPos(startingCamPos:FlxPoint)
	{
		if (startingCamPos == null) return;
	}

	public function onNoteHit(note:Note) {};

	public function sendEvent(name:String, values:Array<String>) {}

	public function initChar() {}
	
	public function getFrames() {};

}
