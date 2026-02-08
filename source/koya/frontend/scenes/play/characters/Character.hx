package koya.frontend.scenes.play.characters;

import koya.backend.play.ObjectManager;
import koya.backend.CoolUtil;
import koya.backend.play.CharacterData;
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

	/** For character editor **/
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
		datapathprefix = DEFAULT_DATAPATHPREFIX;
	}

	/** Set `curCharacter` and `iconChar` **/
	public function setCharacter(character:String = 'bf')
	{
		curCharacter = character;
		this.iconChar = character;
	}

	public var flipAnimationsAsPlayer:Bool = true;

	/** Load character assets, Animations, Offsets, etc **/
	public function loadAssets()
	{
		trace('Loading character: $curCharacter');
		initCharJSON();
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
				var oldRight = anim.getByName('singRIGHT')?.frames;
				if (oldRight != null)
				{
					anim.getByName('singRIGHT').frames = anim.getByName('singLEFT').frames;
					anim.getByName('singLEFT').frames = oldRight;
				}

				// IF THEY HAVE MISS ANIMATIONS??
				if (anim.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = anim.getByName('singRIGHTmiss')?.frames;
					if (oldMiss != null)
					{
						anim.getByName('singRIGHTmiss').frames = anim.getByName('singLEFTmiss').frames;
						anim.getByName('singLEFTmiss').frames = oldMiss;
					}
				}
			}
		}
	}

	/** For opponents this is the hold timer stuff until next idle **/
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

	/** Mainly for characters with `danceLeft` and `danceRight` animations : This will tell which direction you're on **/
	public var danced:Bool = false;

	/** Play idle animations **/
	public function dance()
	{
		if (!debugMode) playAnim('idle');
	}

	public final DEFAULT_DATAPATHPREFIX:String = 'data/characters/::curCharacter::/';
	public var datapathprefix:String = null;

	public function getDataPathPrefix():String
		return new Template(datapathprefix).execute(
			{
				curCharacter: curCharacter
			});

	public function getDataPathLibrary():String
		return 'characters';

	public function getCharacterJSON():String
		return AssetPaths.json('data/characters/$curCharacter', getDataPathLibrary());

	public function getAnimationOffsetsPath():String
		return AssetPaths.txt('${getDataPathPrefix()}anim_offsets', getDataPathLibrary());

	public function getCharacterOffsetsPath():String
		return AssetPaths.txt('${getDataPathPrefix()}character_offsets', getDataPathLibrary());

	public function getCameraOffsetsPath():String
		return AssetPaths.txt('${getDataPathPrefix()}camera_offsets', getDataPathLibrary());

	/** Load Character Offsets from the `.txt` file **/
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

	/** For when the camera moves to this character during gameplay **/
	public function cameraMoveToMe() {}

	/** Load Camera Offsets from the `.txt` file **/
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

	/** Load Animation Offsets from the `.txt` file **/
	public function getAnimationOffsets()
	{
		var offsetPath = getAnimationOffsetsPath();

		if (!KoyaAssets.exists(offsetPath)) return;

		trace(' * found animation offset file: $offsetPath');
		var offsetfile = KoyaAssets.getText(offsetPath).split('\n');

		parseAnimationOffsetFile(offsetfile);
	}

	/** Add singing animations via `addAnimationFunction` and will include misses if `includeMiss` is true **/
	public function addSingingAnimations(includeMiss:Bool = false, addAnimationFunction:(name:String, prefix:String) -> Void)
	{
		var directions = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

		for (dir in directions)
		{
			addAnimationFunction('sing${dir.toUpperCase()}', 'sing${dir.toUpperCase()}');
			if (includeMiss) addAnimationFunction('sing${dir.toUpperCase()}miss', 'sing${dir.toUpperCase()}miss');
		}
	}

	/** Get the starting camera position for the start of the song **/
	public function getStartingCamPos(startingCamPos:FlxPoint)
	{
		if (startingCamPos == null) return;
	}

	/** When a character hits a note **/
	public function onNoteHit(note:Note) {};

	/** Character Event **/
	public function sendEvent(name:String, values:Array<String>) {}

	/** The Character JSON data **/
	var parsedCharJSON:CharacterData = null;

	/** Initalizes character through code **/
	public function initChar() {}

	/** Initalizes character through JSON **/
	public function initCharJSON()
	{
		var charJSON = getCharacterJSON();

		if (KoyaAssets.exists(charJSON))
		{
			try
			{
				parsedCharJSON = Json.parse(KoyaAssets.getText(charJSON));
			}
			catch (e)
			{
				CoolUtil.alert('Error Parsing Character JSON : $curCharacter!', e.toString());
				trace(e.message);
				parsedCharJSON = null;

				return;
			}

			if (parsedCharJSON == null)
			{
				CoolUtil.alert('Error Parsing Character JSON : $curCharacter!', 'Null / Not parsed correctly?');
				return;
			}
			if (parsedCharJSON.animations == null)
			{
				CoolUtil.alert('Error Parsing Character JSON : $curCharacter!', 'Missing Animations');
				return;
			}
			if (parsedCharJSON.type == null)
			{
				CoolUtil.alert('Error Parsing Character JSON : $curCharacter!', 'Missing Character Type');
				return;
			}
			if (parsedCharJSON.imagePath == null)
			{
				CoolUtil.alert('Error Parsing Character JSON : $curCharacter!', 'Missing Character Image Path');
				return;
			}

			loadCharacterJSONType(parsedCharJSON.type);

			ObjectManager.addObjectAnimationsToSprite(this, parsedCharJSON.animations);

			datapathprefix = parsedCharJSON?.dataPathPrefix ?? DEFAULT_DATAPATHPREFIX;
			iconChar = parsedCharJSON?.iconChar ?? curCharacter;
			flipX = parsedCharJSON?.flipX ?? false;
			flipAnimationsAsPlayer = parsedCharJSON?.flipAnimationsAsPlayer ?? true;
		}
		else
		{
			trace(' * $charJSON doesn\'t exist');
		}
	}

	/** Load Character frames for type of `type` **/
	public function loadCharacterJSONType(type:CharacterType)
	{
		trace(type);
		if (type == SPARROW) frames = AssetPaths.fromSparrow(parsedCharJSON.imagePath, 'characters');
		if (type == ATLAS) frames = AssetPaths.getAnimateAtlas(parsedCharJSON.imagePath, 'characters');
	}

	/** For classes extending this, this is where the sparrow or atlas are loaded **/
	public function getFrames() {};
}
