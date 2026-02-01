package koya.frontend;

import koya.frontend.ui.DifficultySprite;
import koya.frontend.ui.ArrowUI;
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

	override function create()
	{
		super.create();

		var bottomBorder:FunkinSprite = new FunkinSprite();
		add(bottomBorder);
		bottomBorder.makeGraphic(FlxG.width, Math.round(FlxG.height / 2), FlxColor.BLACK);
		bottomBorder.screenCenter(X);
		bottomBorder.y = FlxG.height - bottomBorder.height;

		for (arrow in [arrow_DOWN, arrow_UP])
		{
			arrow.screenCenter();
			arrow.y = FlxG.height;
			add(arrow);
		}

		arrow_UP.y -= arrow_UP.height * 6;
		arrow_DOWN.y -= arrow_DOWN.height * 2;

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
	public var currentDifficulty:Int = Difficulty.NORMAL;
	public var currentDifficultyEnum:Difficulty;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (currentDifficulty < 0) currentDifficulty = 0;
		if (currentDifficulty > Difficulty.list.length - 1) currentDifficulty = Difficulty.list.length - 1;

		currentDifficultyEnum = currentDifficulty;

		songDifficultySprite.difficulty = currentDifficulty;
		songDifficultySprite.y = FlxG.height - songDifficultySprite.height * 2;
	}

	override function select(change:Int = 0)
	{
		super.select(change);

		for (menuItem in itemsGroup.members)
			menuItem.y -= menuItem.height * 1.3;
	}
}
