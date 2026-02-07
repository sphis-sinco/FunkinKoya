package koya.frontend.scenes.freeplay;

import koya.frontend.ui.menustate.MenuState;
import koya.frontend.scenes.menustates.*;
import koya.backend.play.Rank;
import koya.frontend.scenes.play.characters.Character;
import koya.backend.songs.SongList;
import koya.frontend.scenes.play.HealthIcon;
import koya.backend.KoyaAssets;
import koya.backend.save.Save;
import koya.frontend.ui.DifficultySprite;
import koya.backend.play.Difficulty;
import flixel.tweens.FlxTween;
import koya.backend.Highscore;
import koya.backend.songs.Song;
import koya.frontend.scenes.play.PlayState;
import flixel.text.FlxText;
import koya.backend.Conductor;
import koya.frontend.ui.ArrowUI;
import koya.backend.Constants;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import koya.backend.AssetPaths;
import flixel.addons.display.FlxGridOverlay;
import koya.backend.CoolUtil;

using StringTools;

class FreeplayState extends MenuState
{
	public var songList:Array<SwagSong> = [];

	public var songScoreText:FlxText = new FlxText();
	public var songAuthorText:FlxText = new FlxText();

	public var songDifficultySprite:DifficultySprite;

	public var currentSong(get, never):SwagSong;

	function get_currentSong():SwagSong
		return songList[currentSelection];

	public var currentSongName(get, never):String;

	function get_currentSongName():String
		return currentSong?.song ?? 'Unknown';

	public var currentSongChart(get, never):String;

	function get_currentSongChart():String
		return Highscore.formatToDifficulty(currentSongName.toLowerCase(), currentDifficulty);

	public var currentScore(get, never):Int;

	function get_currentScore():Int
	{
		if (Save.songScores.get() == null) return 0;
		if (!Save.songScores.get().exists(currentSongChart)) return 0;

		return Save.songScores.get().get(currentSongChart);
	}

	public var currentRank(get, never):String;

	function get_currentRank():String
	{
		if (Save.songRanks.get() == null) return null;
		if (!Save.songRanks.get().exists(currentSongChart)) return null;

		return Save.songRanks.get().get(currentSongChart);
	}

	public var currentDifficulty:Int = Difficulty.NORMAL;
	public var currentDifficultyEnum:Difficulty;

	public var opponentIcon:HealthIcon;
	public var playerIcon:HealthIcon;

	override public function new()
	{
		super('', Vertical);

		this.text = true;
		this.itemList = SongList.stringSongList;
		this.songList = SongList.songList;
	}

	override function create()
	{
		super.create();

		remove(itemsTextGroup);

		remove(pinkBG);
		remove(flashBG);

		initBordersAndArrows();

		add(itemsTextGroup);

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

		opponentIcon = new HealthIcon('dad');
		playerIcon = new HealthIcon('bf', true);
		add(opponentIcon);
		add(playerIcon);

		songScoreText.font = AssetPaths.font('vcr.ttf');
		songAuthorText.font = AssetPaths.font('vcr.ttf');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		performControls();

		FlxG.watch.addQuick('currentScore', currentScore);

		songDifficultySprite.difficulty = currentDifficulty;
		songDifficultySprite.screenCenter(Y);
		songDifficultySprite.x = rightBorder.innerSprite.getGraphicMidpoint().x - (songDifficultySprite.width / 2);

		songScoreText.text = '\nScore (${currentDifficultyEnum.toString()}):\n';
		if (currentScore < 0) songScoreText.text += '-';
		songScoreText.text += '${Math.abs(currentScore)}'.lpad('0', 8);

		songAuthorText.text = 'Composer(s):\n${currentSong.authors}';
		songAuthorText.y = downBorder.innerSprite.getGraphicMidpoint().y - (songAuthorText.height / 2);
	}

	public function performControls()
	{
		if (controls.UI_LEFT_R)
		{
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
			currentDifficulty -= 1;

			arrow_LEFT.x -= 10;
			FlxTween.cancelTweensOf(arrow_LEFT);
			FlxTween.tween(arrow_LEFT, {x: aL_x}, .1);
			applyChartCheck();
		}
		if (controls.UI_RIGHT_R)
		{
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
			currentDifficulty += 1;

			arrow_RIGHT.x += 10;
			FlxTween.cancelTweensOf(arrow_RIGHT);
			FlxTween.tween(arrow_RIGHT, {x: aR_x}, .1);
			applyChartCheck();
		}

		if (controls.ACCEPT)
		{
			if (!KoyaAssets.exists(AssetPaths.chart(currentSongName.toLowerCase(), currentSongChart))) return;

			transitioning = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(AssetPaths.sound('confirmMenu', 'ui'));

			PlayState.loadSong(currentSongChart, currentSongName, currentDifficulty);
			FlxG.switchState(() -> new PlayState());
		}

		if (currentDifficulty < 0) currentDifficulty = Difficulty.list.length - 1;
		if (currentDifficulty > Difficulty.list.length - 1) currentDifficulty = 0;

		currentDifficultyEnum = currentDifficulty;

		if (currentSelection < 0) currentSelection = songList.length - 1;
		if (currentSelection >= songList.length) currentSelection = 0;

		opponentIcon.char = Character.getCharacter(currentSong?.player2 ?? 'unknown').iconChar ?? currentSong.player2;
		playerIcon.char = Character.getCharacter(currentSong?.player1 ?? 'unknown').iconChar ?? currentSong.player1;

		opponentIcon.screenCenter();
		playerIcon.screenCenter();

		opponentIcon.x -= opponentIcon.width;
		playerIcon.x += playerIcon.width;

		opponentIcon.visible = opponentIcon.frames != null;
		playerIcon.visible = playerIcon.frames != null;
	}

	override function back()
	{
		transitioning = true;
		FlxG.sound.play(AssetPaths.sound('cancelMenu', 'ui'));
		FlxG.switchState(() -> new MainMenuState());
	}

	public function applyChartCheck()
	{
		for (menuItem in itemsTextGroup)
		{
			var song:String = menuItem.text;
			var chart:String = Highscore.formatToDifficulty(menuItem.text, currentDifficulty);

			if (!KoyaAssets.exists(AssetPaths.chart(song.toLowerCase(), chart))) menuItem.alpha -= .4;
		}
	}

	override function select(change:Int = 0)
	{
		super.select(change);

		applyChartCheck();

		for (menuItem in itemsTextGroup.members)
			menuItem.x -= menuItem.width * 2;
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

		for (arrow in [arrow_LEFT, arrow_RIGHT])
		{
			arrow.screenCenter();
			add(arrow);
		}

		arrow_LEFT.x = rightBorder.outerSprite.getGraphicMidpoint().x - arrow_LEFT.width * 4;
		arrow_RIGHT.x = rightBorder.outerSprite.getGraphicMidpoint().x + arrow_RIGHT.width * 4;

		aL_x = arrow_LEFT.x;
		aR_x = arrow_RIGHT.x;
	}

	var leftBorder:FreeplayBorderSprite;
	var downBorder:FreeplayBorderSprite;
	var upBorder:FreeplayBorderSprite;
	var rightBorder:FreeplayBorderSprite;

	var arrow_LEFT:ArrowUI = new ArrowUI(LEFT, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);
	var arrow_RIGHT:ArrowUI = new ArrowUI(RIGHT, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);

	var aL_x:Float = 0.0;
	var aR_x:Float = 0.0;
}
