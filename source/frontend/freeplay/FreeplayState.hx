package frontend.freeplay;

import lime.utils.Assets;
import backend.save.Save;
import frontend.ui.DifficultySprite;
import backend.play.Difficulty;
import flixel.tweens.FlxTween;
import backend.Highscore;
import backend.Song;
import frontend.play.PlayState;
import flixel.text.FlxText;
import backend.Conductor;
import frontend.ui.ArrowUI;
import backend.Constants;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import backend.AssetPaths;
import flixel.addons.display.FlxGridOverlay;
import backend.CoolUtil;

using StringTools;

class FreeplayState extends MusicBeatState
{
	public var songList:Array<SwagSong> = [];

	public var songText:FlxText = new FlxText();
	public var songScoreText:FlxText = new FlxText();
	public var songAuthorText:FlxText = new FlxText();

	public var songDifficultySprite:DifficultySprite;

	public var currentSong(get, never):SwagSong;

	function get_currentSong():SwagSong
		return songList[currentSelection];

	public var currentSongName(get, never):String;

	function get_currentSongName():String
		return currentSong.song;

	public var currentSongChart(get, never):String;

	function get_currentSongChart():String
		return Highscore.formatSong(currentSongName, currentDifficulty);

	public var currentScore(get, never):Int;

	function get_currentScore():Int
	{
		if (Save.songScores.get() == null)
			return 0;
		if (!Save.songScores.get().exists(currentSongChart))
			return 0;

		return Save.songScores.get().get(currentSongChart);
	}

	public var currentDifficulty:Int = Difficulty.NORMAL;
	public var currentDifficultyEnum:Difficulty;
	public var currentSelection:Int = 0;

	override function create()
	{
		super.create();

		var freeplaySonglist = CoolUtil.coolTextFile(AssetPaths.txt('data/freeplaySonglist'));
		songList = [];
		var stringsongList:Array<String> = [];
		for (song in freeplaySonglist)
		{
			var myJSON = Song.loadFromJson(song, song, false);
			if (myJSON != null)
			{
				stringsongList.push(myJSON.song);
				songList.push(myJSON);
			}
		}
		trace(stringsongList);

		#if FREEPLAY_BG_GRID
		var GRID_SIZE = 32;
		var gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, (GRID_SIZE * Std.int(FlxG.width / GRID_SIZE)) + 10,
			(GRID_SIZE * Std.int(FlxG.height / GRID_SIZE)) + 10);
		add(gridBG);
		#end

		initBordersAndArrows();

		songText.fieldWidth = sideBorderWidths;
		songText.alignment = CENTER;
		songText.size = 48;

		songText.setBorderStyle(OUTLINE, FlxColor.BLACK, 8);

		add(songText);

		songScoreText.fieldWidth = upBorder.innerSprite.width;
		songScoreText.alignment = CENTER;
		songScoreText.size = 32;

		songScoreText.x = upBorder.innerSprite.x;
		songScoreText.y -= 8;

		add(songScoreText);

		songAuthorText.fieldWidth = downBorder.innerSprite.width;
		songAuthorText.alignment = CENTER;
		songAuthorText.size = 32;

		songAuthorText.x = downBorder.innerSprite.x;

		add(songAuthorText);

		songDifficultySprite = new DifficultySprite(currentDifficulty);
		add(songDifficultySprite);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		performControls();

		if (currentDifficulty < 0)
			currentDifficulty = 0;
		if (currentDifficulty > Difficulty.list.length - 1)
			currentDifficulty = Difficulty.list.length - 1;

		currentDifficultyEnum = currentDifficulty;

		if (currentSelection < 0)
			currentSelection = 0;
		if (currentSelection >= songList.length)
			currentSelection = songList.length - 1;

		FlxG.watch.addQuick('currentScore', currentScore);

		songDifficultySprite.difficulty = currentDifficulty;
		songDifficultySprite.screenCenter(Y);
		songDifficultySprite.x = rightBorder.innerSprite.getGraphicMidpoint().x - (songDifficultySprite.width / 2);

		arrow_UP.alpha = (currentSelection == 0) ? 0.5 : 1;
		arrow_DOWN.alpha = (currentSelection == songList.length - 1) ? 0.5 : 1;

		arrow_LEFT.alpha = (currentDifficulty == Difficulty.EASY.toInt()) ? 0.5 : 1;
		arrow_RIGHT.alpha = (currentDifficulty == Difficulty.HARD.toInt()) ? 0.5 : 1;

		songText.text = currentSongName;
		songText.screenCenter(Y);

		songScoreText.text = '\nScore (${currentDifficultyEnum.toString()}):\n';
		if (currentScore < 0)
			songScoreText.text += '-';
		songScoreText.text += '${Math.abs(currentScore)}'.lpad('0', 8);

		songAuthorText.text = 'Composers:\n${currentSong.authors}';
		songAuthorText.y = downBorder.innerSprite.getGraphicMidpoint().y - (songAuthorText.height / 2);

		songText.alpha = 1;
		if (!Assets.exists(AssetPaths.chart(currentSongName.toLowerCase(), currentSongChart)))
			songText.alpha = .5;

		if ((FlxG.sound.music == null || !FlxG.sound.music.playing) && !transitioning)
		{
			FlxG.sound.playMusic(AssetPaths.music('freakyMenu'), 0.7, false);
			Conductor.changeBPM(102);
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	public var transitioning:Bool = false;

	public function performControls()
	{
		if (controls.UI_UP_R)
		{
			currentSelection--;
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));

			arrow_UP.y -= 10;
			FlxTween.cancelTweensOf(arrow_UP);
			FlxTween.tween(arrow_UP, {y: aU_y}, .1);
		}
		if (controls.UI_DOWN_R)
		{
			currentSelection++;
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));

			arrow_DOWN.y += 10;

			FlxTween.cancelTweensOf(arrow_DOWN);
			FlxTween.tween(arrow_DOWN, {y: aD_y}, .1);
		}

		if (controls.UI_LEFT_R)
		{
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
			currentDifficulty -= 1;

			arrow_LEFT.x -= 10;
			FlxTween.cancelTweensOf(arrow_LEFT);
			FlxTween.tween(arrow_LEFT, {x: aL_x}, .1);
		}
		if (controls.UI_RIGHT_R)
		{
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
			currentDifficulty += 1;

			arrow_RIGHT.x += 10;
			FlxTween.cancelTweensOf(arrow_RIGHT);
			FlxTween.tween(arrow_RIGHT, {x: aR_x}, .1);
		}

		if (controls.BACK)
		{
			transitioning = true;
			FlxG.sound.play(AssetPaths.sound('cancelMenu', 'ui'));
			FlxG.switchState(() -> new TitleState());
		}

		if (controls.ACCEPT)
		{
			if (!Assets.exists(AssetPaths.chart(currentSongName.toLowerCase(), currentSongChart)))
				return;

			transitioning = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(AssetPaths.sound('confirmMenu', 'ui'));

			PlayState.SONG = Song.loadFromJson(currentSongChart, currentSongName);
			PlayState.SONG_DIFFICULTY = currentDifficulty;
			PlayState.chartingMode = false;

			FlxG.switchState(() -> new PlayState());
		}
	}

	public var sideBorderWidths = 320 + 64;

	public function initBordersAndArrows()
	{
		upBorder = new FreeplayBorderSprite(FlxG.width - ((sideBorderWidths * 2) - Constants.FREEPLAY_BORDER_INNER_PADDING), 160, sideBorderWidths, 0);
		add(upBorder);
		upBorder.innerSprite.y -= Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		downBorder = new FreeplayBorderSprite(FlxG.width - ((sideBorderWidths * 2) - Constants.FREEPLAY_BORDER_INNER_PADDING), 160, sideBorderWidths,
			FlxG.height - 160);
		add(downBorder);
		downBorder.innerSprite.y += Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		leftBorder = new FreeplayBorderSprite(sideBorderWidths, Std.int(FlxG.height + Constants.FREEPLAY_BORDER_INNER_PADDING), 0,
			-Constants.FREEPLAY_BORDER_INNER_PADDING / 2);
		add(leftBorder);
		leftBorder.innerSprite.x -= Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		rightBorder = new FreeplayBorderSprite(sideBorderWidths, Std.int(FlxG.height + Constants.FREEPLAY_BORDER_INNER_PADDING),
			FlxG.width - sideBorderWidths, -Constants.FREEPLAY_BORDER_INNER_PADDING / 2);
		add(rightBorder);
		rightBorder.innerSprite.x += Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		for (arrow in [arrow_DOWN, arrow_LEFT, arrow_RIGHT, arrow_UP])
		{
			arrow.screenCenter();
			add(arrow);
		}

		arrow_DOWN.x = leftBorder.outerSprite.getGraphicMidpoint().x - arrow_DOWN.width;
		arrow_UP.x = leftBorder.outerSprite.getGraphicMidpoint().x - arrow_UP.width;

		arrow_LEFT.x = rightBorder.outerSprite.getGraphicMidpoint().x - arrow_LEFT.width * 4;
		arrow_RIGHT.x = rightBorder.outerSprite.getGraphicMidpoint().x + arrow_RIGHT.width * 4;

		arrow_UP.y -= arrow_UP.height * 2;
		arrow_DOWN.y += arrow_DOWN.height * 2;

		aU_y = arrow_UP.y;
		aD_y = arrow_DOWN.y;

		aL_x = arrow_LEFT.x;
		aR_x = arrow_RIGHT.x;
	}

	var leftBorder:FreeplayBorderSprite;
	var downBorder:FreeplayBorderSprite;
	var upBorder:FreeplayBorderSprite;
	var rightBorder:FreeplayBorderSprite;

	var arrow_UP:ArrowUI = new ArrowUI(UP);
	var arrow_DOWN:ArrowUI = new ArrowUI(DOWN);

	var arrow_LEFT:ArrowUI = new ArrowUI(LEFT, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);
	var arrow_RIGHT:ArrowUI = new ArrowUI(RIGHT, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);

	var aU_y:Float = 0.0;
	var aD_y:Float = 0.0;

	var aL_x:Float = 0.0;
	var aR_x:Float = 0.0;
}
