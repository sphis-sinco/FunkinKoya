package koya.frontend.scenes;

import flixel.tweens.FlxTween;
import koya.backend.AssetPaths;
import koya.frontend.ui.DifficultySprite;
import koya.frontend.ui.ArrowUI;
import koya.backend.Constants;
import flixel.util.FlxColor;
import flixel.FlxG;
import koya.backend.play.Difficulty;
import koya.frontend.scenes.play.PlayState;
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

	var aU_y:Float = 0;
	var aD_y:Float = 0;

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

		arrow_UP.y -= arrow_UP.height * 7;
		arrow_DOWN.y -= arrow_DOWN.height * 3;

		aU_y = arrow_UP.y;
		aD_y = arrow_DOWN.y;

		songDifficultySprite = new DifficultySprite(currentDifficulty);
		add(songDifficultySprite);
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

		if (PlayState.STORYMODE_PLAYLIST.length > 0)
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

		if (controls.UI_UP_R)
		{
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
			currentDifficulty -= 1;

			arrow_UP.y -= 10;
			FlxTween.cancelTweensOf(arrow_UP);
			FlxTween.tween(arrow_UP, {y: aU_y}, .1);
		}
		if (controls.UI_DOWN_R)
		{
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
			currentDifficulty += 1;

			arrow_DOWN.y += 10;
			FlxTween.cancelTweensOf(arrow_DOWN);
			FlxTween.tween(arrow_DOWN, {y: aD_y}, .1);
		}

		if (currentDifficulty < 0) currentDifficulty = 0;
		if (currentDifficulty > Difficulty.list.length - 1) currentDifficulty = Difficulty.list.length - 1;

		arrow_UP.alpha = (currentDifficulty == Difficulty.list[0].toInt()) ? 0.5 : 1;
		arrow_DOWN.alpha = (currentDifficulty == Difficulty.list[Difficulty.list.length - 1].toInt()) ? 0.5 : 1;

		currentDifficultyEnum = currentDifficulty;

		songDifficultySprite.difficulty = currentDifficulty;
		songDifficultySprite.screenCenter(X);
		songDifficultySprite.y = FlxG.height - songDifficultySprite.height * 2.5;
	}

	override function select(change:Int = 0)
	{
		super.select(change);

		for (menuItem in itemsGroup.members)
			menuItem.y -= menuItem.height * 1.3;
	}
}
