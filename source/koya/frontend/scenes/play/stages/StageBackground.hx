package koya.frontend.scenes.play.stages;

import lime.app.Application;
import haxe.Json;
import koya.backend.KoyaAssets;
import flixel.graphics.frames.FlxAtlasFrames;
import koya.backend.AssetPaths;
import koya.frontend.scenes.play.characters.CharacterGetter;
import koya.backend.songs.Song.SwagSong;
import flixel.math.FlxPoint;
import koya.frontend.scenes.play.characters.Character;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class StageBackground extends FlxTypedGroup<FlxBasic>
{
	public function getPropOffsets()
	{
		var offsetPath = getStagePropOffsetPath();

		if (!KoyaAssets.exists(offsetPath)) return;

		trace('found stage prop value file: $offsetPath');

		var offsetfile:Dynamic = {};
		try
		{
			offsetfile = Json.parse(KoyaAssets.getText(offsetPath));
		}
		catch (e)
		{
			Application.current.window.alert('Error while reading Stage Prop Offsets file: $offsetPath:\n\n${e.message}', 'Invalid Stage Prop Offsets File!');
			return;
		}

		for (prop in Reflect.fields(offsetfile))
		{
			if (getThing(prop) == null)
			{
				trace('skipped $prop : null');
				continue;
			}

			var propNam:String = prop;
			var propData:Dynamic = Reflect.field(offsetfile, prop);
			var propChangedFields = Reflect.fields(propData);

			for (field in propChangedFields)
			{
				try
				{
					Reflect.setField(getThing(propNam), field, Reflect.field(propData, field));
					trace('set $field of $propNam to ${Reflect.field(propData, field)} (og value: ${Reflect.field(getThing(propNam), field)})');
				}
				catch (e)
				{
					trace('error setting $field of $propNam to ${Reflect.field(propData, field)} : ${e.message}');
				}
			}
		};
	}

	public function getJSONPathBase():String
		return 'data/stages/$BG_NAME';

	public function getStagePropOffsetPath():String
		return AssetPaths.json(getJSONPathBase() + '-propvalues', 'backgrounds');

	public function getBGImg(path:String):String
		return AssetPaths.image('bg/${BG_NAME != null ? '$BG_NAME/' : ''}$path', 'backgrounds');

	public function getBGSparrowImg(path:String):FlxAtlasFrames
		return AssetPaths.fromSparrow('bg/${BG_NAME != null ? '$BG_NAME/' : ''}$path', 'backgrounds');

	private var songData:SwagSong;

	public function getThing(thing:String)
		return Reflect.field(this, thing);

	public static function getStage(song:SwagSong):StageBackground
		return StageBackgroundGetter.getStage(song, song.stage ?? 'mainStage');

	public var BG_NAME:String = null;

	override public function new(song:SwagSong, ?BG_NAME:String = 'Unknown', ?performInit:Bool = true)
	{
		super();

		this.songData = song;
		this.BG_NAME = BG_NAME;

		if (performInit) init();
	}

	var startingCamPos:FlxPoint;

	public function init()
	{
		initInfo();

		trace('Loading stage: $BG_NAME');

		initBG();
		if (songData != null) initChars();
		initFG();

		getPropOffsets();

		setCamera();

		if (dad != null && gf != null) if (dad.curCharacter == gf.curCharacter)
		{
			dad.setPosition(gf.x, gf.y);
			gf.visible = false;
		}
	}

	public function setCamera()
	{
		if (PlayState.instance == null) return;

		if (startingCamPos != null) PlayState.instance.camFollow.setPosition(startingCamPos.x, startingCamPos.y);
		else
			PlayState.instance.camFollow.screenCenter();
	}

	public function initInfo()
	{
		PlayState.SONG_STAGE = BG_NAME;
		if (PlayState.instance != null) PlayState.instance.defaultCamZoom = 1.05;
	}

	public function initBG() {}

	public function initFG() {}

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	public function initChars()
	{
		if (songData?.gfVersion != null)
		{
			gf = Character.getCharacter(songData?.gfVersion, false, 0, 0);
			gf.scrollFactor.set(0.95, 0.95);
		}

		if (songData?.player2 != null) dad = Character.getCharacter(songData?.player2, false, 0, 0);

		if (songData?.player1 != null) boyfriend = Character.getCharacter(songData?.player1, true, 0, 0);

		for (char in [gf, dad, boyfriend])
		{
			char.loadAssets();
			if (char != null) add(char);
		}

		for (char in [dad, gf, boyfriend])
		{
			if (char == null) continue;

			if (startingCamPos == null) startingCamPos = FlxPoint.get(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);
			char.getStartingCamPos(startingCamPos);
		}
	}

	public function getGameoverCharacter():Character
		return null;

	public function getGameoverStageSuffix():String
		return '';

	public function countdownTick(tick:Int = 0)
	{
		if (dad != null) dad.dance();
		if (gf != null) gf.dance();
		if (boyfriend != null) boyfriend.dance();
	}

	public function makeCharacterSing(note:Note, character:Character, ?miss:Bool = false, ?addition:String)
	{
		character.onNoteHit(note);
		character.playAnim(Note.getSingAnimation(note, PlayState.SONG, miss, addition), true);
	}

	public function stepHit(step:Int) {};

	public function beatHit(beat:Int) {};

	public function sectionHit(section:Int) {};

	public function moveCamera(bf:Bool)
	{
		for (char in [(bf) ? boyfriend : dad])
		{
			if (char == null) continue;

			PlayState.instance.camFollow.x += char.cameraOffsets[0];
			PlayState.instance.camFollow.y += char.cameraOffsets[1];

			char.cameraMoveToMe();
		}
	};

	public function sendEvent(name:String, values:Array<String>) {}
}
