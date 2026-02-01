package koya.backend;

import koya.backend.plugins.Cursor;
import flixel.util.FlxTimer;
import koya.frontend.StoryModeState;
import koya.backend.songs.Song;
import koya.backend.play.Difficulty;
import lime.utils.Assets;
import haxe.macro.Compiler;
import koya.frontend.play.PlayState;
import koya.frontend.MainMenuState;
import koya.frontend.TitleState;
import koya.frontend.play.editors.ChartingState;
import koya.frontend.freeplay.FreeplayState;
import koya.backend.tasks.ResaveAllSongs;
import koya.backend.save.Save;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import koya.backend.controls.PlayerSettings;
import lime.app.Application;
import flixel.FlxSprite;
import flixel.util.typeLimit.NextState;
import flixel.FlxG;
import koya.frontend.web.TouchHere;
import flixel.FlxState;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		FlxSprite.defaultAntialiasing = true;

		FlxG.plugins.addPlugin(new Cursor());

		var startingState:NextState = getStartingState();

		#if web
		startingState = () -> new TouchHere();
		#end

		Save.init();

		Application.current.window.title = Constants.WINDOW_TITLE;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), null,
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), null,
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		#if TASK_RESAVE_ALL_SONGS
		ResaveAllSongs.run();
		#end

		FlxG.signals.postUpdate.add(function() {
			if (FlxG.keys.pressed.F3 && FlxG.keys.pressed.C)
			{
				throw 'F3 + C';
			}
		});

		new FlxTimer().start(1, function(t) {
			FlxG.switchState(startingState);
		});
	}

	public static function getStartingState():NextState
	{
		#if FREEPLAY
		return () -> new FreeplayState();
		#end

		#if CHARTING
		return () -> new ChartingState();
		#end

		#if MAINMENU
		return () -> new MainMenuState();
		#end

		var SONG = Compiler.getDefine('SONG');
		if (SONG != null && SONG != '1')
		{
			var currentSongName:String = SONG.toLowerCase();
			var currentDifficulty:Difficulty = NORMAL;

			#if DIFFICULTY_EASY
			currentDifficulty = EASY;
			#end
			#if DIFFICULTY_HARD
			currentDifficulty = HARD;
			#end

			var currentSongChart:String = Highscore.formatSong(currentSongName.toLowerCase(), currentDifficulty);

			if (!Assets.exists(AssetPaths.chart(currentSongName.toLowerCase(), currentSongChart))) return () -> new TitleState();

			PlayState.loadSong(currentSongChart, currentSongName, currentDifficulty);
			return () -> new PlayState();
		}

		#if STORYMODE
		return () -> new StoryModeState();
		#end

		return () -> new TitleState();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
