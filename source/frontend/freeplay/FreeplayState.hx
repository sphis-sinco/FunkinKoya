package frontend.freeplay;

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

class FreeplayState extends MusicBeatState
{
	public var songList:Array<String> = [];
	public var songText:FlxText = new FlxText();

	public var songSelect:Int = 0;
	public var songDifficulty:Int = 1;

	override function create()
	{
		super.create();

		songList = CoolUtil.coolTextFile(AssetPaths.txt('data/freeplaySonglist'));
		trace(songList);

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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var prevSel:Int = songSelect;

		performControls();

		if (songSelect < 0)
			songSelect = 0;
		if (songSelect >= songList.length)
			songSelect = songList.length - 1;

		arrow_UP.alpha = (songSelect == 0) ? 0.5 : 1;
		arrow_DOWN.alpha = (songSelect == songList.length - 1) ? 0.5 : 1;

		if (songSelect != prevSel)
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));

		songText.text = songList[songSelect].toLowerCase();
		songText.screenCenter(Y);

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
			songSelect--;
		if (controls.UI_DOWN_R)
			songSelect++;

		if (controls.BACK)
		{
			transitioning = true;
			FlxG.sound.play(AssetPaths.sound('cancelMenu', 'ui'));
			FlxG.switchState(() -> new TitleState());
		}

		if (controls.ACCEPT)
		{
			transitioning = true;
			FlxG.sound.music.stop();
			FlxG.sound.play(AssetPaths.sound('confirmMenu', 'ui'));

			PlayState.SONG = Song.loadFromJson(songList[songSelect], Highscore.formatSong(songList[songSelect], songDifficulty));
			PlayState.SONG_DIFFICULTY = songDifficulty;

			FlxG.switchState(() -> new PlayState());
		}
	}

	public var sideBorderWidths = 320 + 64;

	public function initBordersAndArrows()
	{
		var upBorder = new FreeplayBorderSprite(FlxG.width - ((sideBorderWidths * 2) - Constants.FREEPLAY_BORDER_INNER_PADDING), 160, sideBorderWidths, 0);
		add(upBorder);
		upBorder.innerSprite.y -= Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		var downBorder = new FreeplayBorderSprite(FlxG.width - ((sideBorderWidths * 2) - Constants.FREEPLAY_BORDER_INNER_PADDING), 160, sideBorderWidths,
			FlxG.height - 160);
		add(downBorder);
		downBorder.innerSprite.y += Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		var leftBorder = new FreeplayBorderSprite(sideBorderWidths, Std.int(FlxG.height + Constants.FREEPLAY_BORDER_INNER_PADDING), 0,
			-Constants.FREEPLAY_BORDER_INNER_PADDING / 2);
		add(leftBorder);
		leftBorder.innerSprite.x -= Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		var rightBorder = new FreeplayBorderSprite(sideBorderWidths, Std.int(FlxG.height + Constants.FREEPLAY_BORDER_INNER_PADDING),
			FlxG.width - sideBorderWidths, -Constants.FREEPLAY_BORDER_INNER_PADDING / 2);
		add(rightBorder);
		rightBorder.innerSprite.x += Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		var arrow_LEFT:ArrowUI = new ArrowUI(LEFT, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);
		var arrow_RIGHT:ArrowUI = new ArrowUI(RIGHT, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);

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
	}

	var arrow_UP:ArrowUI = new ArrowUI(UP);
	var arrow_DOWN:ArrowUI = new ArrowUI(DOWN);
}
