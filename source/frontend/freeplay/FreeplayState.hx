package frontend.freeplay;

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

		var upBorder = new FreeplayBorderSprite(FlxG.width - (640 - Constants.FREEPLAY_BORDER_INNER_PADDING), 160, 320, 0);
		add(upBorder);
		upBorder.innerSprite.y -= Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		var downBorder = new FreeplayBorderSprite(FlxG.width - (640 - Constants.FREEPLAY_BORDER_INNER_PADDING), 160, 320, FlxG.height - 160);
		add(downBorder);
		downBorder.innerSprite.y += Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		var leftBorder = new FreeplayBorderSprite(320, Std.int(FlxG.height + Constants.FREEPLAY_BORDER_INNER_PADDING), 0,
			-Constants.FREEPLAY_BORDER_INNER_PADDING / 2);
		add(leftBorder);
		leftBorder.innerSprite.x -= Constants.FREEPLAY_BORDER_INNER_PADDING / 2;

		var rightBorder = new FreeplayBorderSprite(320, Std.int(FlxG.height + Constants.FREEPLAY_BORDER_INNER_PADDING), FlxG.width - 320,
			-Constants.FREEPLAY_BORDER_INNER_PADDING / 2);
		add(rightBorder);
		rightBorder.innerSprite.x += Constants.FREEPLAY_BORDER_INNER_PADDING / 2;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
