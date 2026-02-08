package koya.frontend.scenes.menustates;

import koya.backend.CoolUtil;
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

	var arrow_UP:ArrowUI = new ArrowUI(UP, ArrowUI.SKIN_DIFFICULTY_SELECT);
	var arrow_DOWN:ArrowUI = new ArrowUI(DOWN, ArrowUI.SKIN_DIFFICULTY_SELECT);

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

		loadWeek(item);
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
		else
		{
			CoolUtil.alert('Could not load week',
				'Error loading week, check for these possibilities:\n\n'
				+ '- Missing difficulty file for the first song\n'
				+ '- Missing week JSON\n'
				+ '- Missing week JSON "songs" field\n');
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

		if (currentDifficulty < 0) currentDifficulty = Difficulty.list.length - 1;
		if (currentDifficulty > Difficulty.list.length - 1) currentDifficulty = 0;

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

		for (menuItem in itemsSpriteGroup.members)
			menuItem.y -= menuItem.height * 1.3;
	}

	override function back()
	{
		FlxG.switchState(() -> new MainMenuState());
	}
}
