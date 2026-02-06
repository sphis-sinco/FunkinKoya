package koya.backend;

import koya.backend.plugins.Cursor;
import flixel.util.*;
import koya.backend.songs.Song;
import koya.backend.play.Difficulty;
import koya.backend.KoyaAssets;
import haxe.macro.Compiler;
import koya.frontend.scenes.*;
import koya.frontend.scenes.web.*;
import koya.frontend.scenes.play.*;
import koya.frontend.scenes.play.scenes.*;
import koya.frontend.scenes.play.scenes.menustates.*;
import koya.frontend.scenes.play.scenes.freeplay.*;
import koya.frontend.scenes.play.scenes.editors.*;
import koya.backend.tasks.*;
import koya.backend.save.Save;
import koya.backend.*;
import flixel.math.*;
import flixel.addons.transition.*;
import koya.backend.controls.PlayerSettings;
import lime.app.Application;
import flixel.util.typeLimit.NextState;
import flixel.*;

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

			var currentSongChart:String = Highscore.formatToDifficulty(currentSongName.toLowerCase(), currentDifficulty);

			if (!KoyaAssets.exists(AssetPaths.chart(currentSongName.toLowerCase(), currentSongChart))) return () -> new TitleState();

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
