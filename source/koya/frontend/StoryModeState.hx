package koya.frontend;

import koya.backend.Constants;
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

	var arrow_UP:ArrowUI = new ArrowUI(UP, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);
	var arrow_DOWN:ArrowUI = new ArrowUI(DOWN, Constants.UI_ARROW_SKIN_DIFFICULTY_SELECT);

	var aU_y:Float = 0.0;
	var aD_y:Float = 0.0;

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

		for (arrow in [arrow_DOWN, arrow_UP])
		{
			arrow.screenCenter();
			arrow.y = FlxG.height;
			add(arrow);
		}

		arrow_UP.y -= arrow_UP.height * 4;
		arrow_DOWN.y -= arrow_DOWN.height * 2;

		aU_y = arrow_UP.y;
		aD_y = arrow_DOWN.y;

		songDifficultySprite = new DifficultySprite(currentDifficulty);
		add(songDifficultySprite);
		songDifficultySprite.screenCenter();
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

	public var songDifficultySprite:DifficultySprite;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (currentDifficulty < 0) currentDifficulty = 0;
		if (currentDifficulty > Difficulty.list.length - 1) currentDifficulty = Difficulty.list.length - 1;

		currentDifficultyEnum = currentDifficulty;

		songDifficultySprite.difficulty = currentDifficulty;
		songDifficultySprite.y = FlxG.height - songDifficultySprite.height * 4;
	}
}
