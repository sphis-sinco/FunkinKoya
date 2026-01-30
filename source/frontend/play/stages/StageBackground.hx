package frontend.play.stages;

import lime.utils.Assets;
import flixel.graphics.frames.FlxAtlasFrames;
import backend.AssetPaths;
import frontend.play.characters.CharacterGetter;
import backend.Song.SwagSong;
import flixel.math.FlxPoint;
import frontend.play.characters.Character;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class StageBackground extends FlxTypedGroup<FlxBasic>
{
	public function getPropOffsetss()
	{
		var offsetPath = getStagePropOffsetPath();

		if (!Assets.exists(offsetPath))
			return;

		trace(' * found stage prop offset file: $offsetPath');
		var offsetfile = Assets.getText(offsetPath).split('\n');

		for (line in offsetfile)
		{
			var splitLine = line.split(' ');

			var prop = splitLine[0] ?? null;
			var x = splitLine[1] ?? '0';
			var y = splitLine[2] ?? '0';

			var funkinSprProp:FunkinSprite = cast getThing(prop);
			if (funkinSprProp != null)
			{
				funkinSprProp.x += Std.parseFloat(x);
				funkinSprProp.y += Std.parseFloat(y);
			}
		}
	}

	public function getStagePropOffsetPath():String
		return AssetPaths.txt('data/stages/props/${BG_NAME != null ? '$BG_NAME/' : ''}', 'backgrounds');

	public function getBGImg(path:String):String
		return AssetPaths.image('bg/${BG_NAME != null ? '$BG_NAME/' : ''}$path', 'backgrounds');

	public function getBGSparrowImg(path:String):FlxAtlasFrames
		return AssetPaths.fromSparrow('bg/${BG_NAME != null ? '$BG_NAME/' : ''}$path', 'backgrounds');

	private var songData:SwagSong;

	public function getThing(thing:String):FlxBasic
		return Reflect.field(this, thing);

	public static function getStage(song:SwagSong):StageBackground
		return StageBackgroundGetter.getStage(song, song.stage ?? 'mainStage');

	public var BG_NAME:String = null;

	override public function new(song:SwagSong, ?BG_NAME:String = 'Unknown', ?performInit:Bool = true)
	{
		super();

		this.songData = song;
		this.BG_NAME = BG_NAME;

		if (performInit)
			init();
	}

	var startingCamPos:FlxPoint;

	public function init()
	{
		initInfo();

		trace('Loading stage: $BG_NAME');

		initBG();
		initChars();
		initFG();

		if (startingCamPos != null)
			PlayState.instance.camFollow.setPosition(startingCamPos.x, startingCamPos.y);
		else
			PlayState.instance.camFollow.screenCenter();
	}

	public function initInfo()
	{
		PlayState.SONG_STAGE = BG_NAME;
		PlayState.instance.defaultCamZoom = 1.05;
	}

	public function initBG() {}

	public function initFG() {}

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	public function initChars()
	{
		gf = Character.getCharacter(songData.gfVersion, false, 0, 0);
		gf.scrollFactor.set(0.95, 0.95);

		dad = Character.getCharacter(songData.player2, false, 0, 0);

		if (dad.curCharacter == gf.curCharacter)
		{
			dad.setPosition(gf.x, gf.y);
			gf.visible = false;
		}

		boyfriend = Character.getCharacter(songData.player1, true, 0, 0);

		for (char in [gf, dad, boyfriend])
		{
			if (char != null)
				add(char);
		}

		for (char in [dad, gf, boyfriend])
		{
			if (char == null)
				continue;

			if (startingCamPos == null)
				startingCamPos = FlxPoint.get(char.getGraphicMidpoint().x, char.getGraphicMidpoint().y);
			CharacterGetter.getCharacterStartingCamPos(startingCamPos, char.curCharacter);
		}
	}

	public function getGameoverCharacter():Character
		return Character.getCharacter(songData.player1, true, boyfriend?.x ?? 0, boyfriend?.y ?? 0);

	public function getGameoverStageSuffix():String
		return '';

	public function countdownTick(tick:Int = 0)
	{
		if (dad != null)
			dad.dance();
		if (gf != null)
			gf.dance();
		if (boyfriend != null)
			boyfriend.dance();
	}

	public function makeCharacterSing(note:Note, character:Character, ?miss:Bool = false)
	{
		var animationName:String = 'sing${note.getDirectionName().toUpperCase()}';
		if (miss)
			animationName += 'miss';

		character.playAnim(animationName, true);
	}
}
