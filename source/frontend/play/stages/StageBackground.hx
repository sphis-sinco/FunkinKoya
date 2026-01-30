package frontend.play.stages;

import frontend.play.characters.CharacterGetter;
import backend.Song.SwagSong;
import flixel.math.FlxPoint;
import frontend.play.characters.Character;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class StageBackground extends FlxTypedGroup<FlxBasic>
{
	private var songData:SwagSong;

	public static function getStage(song:SwagSong, ?stage:String = 'mainStage'):StageBackground
		return StageBackgroundGetter.getStage(song, stage);

	override public function new(song:SwagSong)
	{
		super();

		this.songData = song;

		init();
	}

	var startingCamPos:FlxPoint;

	public function init()
	{
		initInfo();
		initBG();
		initChars();
		initFG();

		PlayState.instance.camFollow.setPosition(startingCamPos.x, startingCamPos.y);
	}

	public function initInfo()
	{
		PlayState.SONG_STAGE = 'Unknown';
		PlayState.instance.defaultCamZoom = 1.05;
	}

	public function initBG() {}

	public function initFG() {}

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	public function initChars()
	{
		gf = Character.getCharacter(songData.gfVersion ?? 'gf', false, 0, 0);
		gf.scrollFactor.set(0.95, 0.95);

		dad = Character.getCharacter(songData.player2, false, 0, 0);

		if (dad.curCharacter == gf.curCharacter)
		{
			dad.setPosition(gf.x, gf.y);
			gf.visible = false;
		}

		boyfriend = Character.getCharacter(songData.player1, true, 0, 0);

		add(gf);
		add(dad);
		add(boyfriend);

		startingCamPos = FlxPoint.get(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		CharacterGetter.getCharacterStartingCamPos(startingCamPos, dad.curCharacter);
	}

	public function getGameoverCharacter():Character
		return Character.getCharacter(songData.player1, true, boyfriend?.x ?? 0, boyfriend?.y ?? 0);

	public function getGameoverStageSuffix():String
		return '';
}
