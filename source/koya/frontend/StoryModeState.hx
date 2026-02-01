package koya.frontend;

import flixel.util.FlxColor;
import flixel.FlxG;
import koya.backend.play.Difficulty;
import koya.frontend.play.PlayState;
import koya.backend.songs.SongList;
import koya.frontend.ui.menustate.MenuState;

class StoryModeState extends MenuState
{
	override public function new()
	{
		super('storymode/', Horizontal);

		this.itemList = SongList.weekList.textList;
		this.itemIncOffset += 100;
	}

	override function create()
	{
		super.create();

		var topBorder:FunkinSprite = new FunkinSprite();
		add(topBorder);
		topBorder.makeGraphic(FlxG.width, Math.round(FlxG.height / 4), FlxColor.BLACK);
		topBorder.screenCenter(X);
		topBorder.y = 0;

		var bottomBorder:FunkinSprite = topBorder.clone();
		add(bottomBorder);
		bottomBorder.screenCenter(X);
		bottomBorder.y = FlxG.height - bottomBorder.height;
	}

	override function accept(item:String)
	{
		super.accept(item);

		switch (item.toLowerCase())
		{
			case 'tutorial', 'week1', 'week2':
				loadWeek(item.toLowerCase());
		}
	}

	public var currentDifficulty:Difficulty = NORMAL;

	public function loadWeek(week:String)
	{
		PlayState.loadWeek(SongList.weekList.getEntryFilePath(week), currentDifficulty);

		if (PlayState.playList.length > 0)
		{
			transitioning = true;
			FlxG.sound.music.stop();

			FlxG.switchState(() -> new PlayState());
		}
	}
}
