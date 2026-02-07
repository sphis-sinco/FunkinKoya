package koya.frontend.scenes.play;

import koya.backend.save.Save;
import koya.frontend.scenes.menustates.*;
import koya.backend.songs.EventParser;
import koya.frontend.scenes.play.scenes.*;
import koya.frontend.scenes.play.scenes.editors.*;
import haxe.Json;
import koya.backend.songs.Week;
import koya.backend.KoyaAssets;
import koya.frontend.scenes.play.songs.SongClass;
import koya.frontend.scenes.freeplay.FreeplayState;
import koya.backend.play.*;
import koya.frontend.scenes.play.stages.StageBackground;
import koya.backend.*;
import koya.backend.songs.Section;
import koya.backend.songs.Song;
import flixel.*;
import flixel.group.FlxGroup;
import flixel.math.*;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.*;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.*;

using StringTools;

class PlayState extends MusicBeatState
{
	public static function loadSong(chart:String, song:String, difficulty:Difficulty = NORMAL, chartingMode:Bool = false, storyMode:Bool = false)
	{
		trace('Loading song: ' + AssetPaths.chart(song, chart));

		PlayState.SONG = Song.loadFromJson(chart, song);
		PlayState.SONG_DIFFICULTY = difficulty;
		PlayState.IS_CHARTINGMODE = chartingMode;
		PlayState.IS_STORYMODE = storyMode;

		if (PlayState.SONG == null) PlayState.SONG = Song.dummySong;
	}

	public static function loadWeek(weekPath:String, difficulty:Difficulty = NORMAL, chartingMode:Bool = false, storyMode:Bool = true)
	{
		STORYMODE_PLAYLIST = [];

		if (!KoyaAssets.exists(weekPath))
		{
			trace('Missing week: ' + weekPath);
			return;
		}

		trace('Loading week: ' + weekPath);

		try
		{
			var weekFile:Week = Json.parse(KoyaAssets.getText(weekPath));

			for (song in weekFile.songs)
			{
				var songFile:SwagSong = Song.loadFromJson(Highscore.formatToDifficulty(song.toLowerCase(), difficulty), song.toLowerCase(), false);

				if (songFile != null) STORYMODE_PLAYLIST.push(songFile.song);
			}

			trace('New Playlist: ' + STORYMODE_PLAYLIST);

			STORYMODE_PLAYLIST_NUMBER = 0;
			STORYMODE_WEEK = weekFile.name;
			loadSong(Highscore.formatToDifficulty(STORYMODE_PLAYLIST[0].toLowerCase(), difficulty), STORYMODE_PLAYLIST[0].toLowerCase(), difficulty,
				chartingMode, storyMode);
		}
		catch (e)
		{
			trace(e.message);
		}
	}

	public static var STRUMLINE_Y(get, never):Float;

	static function get_STRUMLINE_Y():Float
	{
		if (Save.preferences.get().downScroll) return FlxG.height * 0.75;

		return 50.0;
	}

	public static var instance:PlayState = null;

	public static var STORYMODE_PLAYLIST:Array<String> = [];
	public static var STORYMODE_PLAYLIST_NUMBER:Int = 0;
	public static var STORYMODE_WEEK:String = '';

	public static var SONG:SwagSong;
	public static var SONG_DIFFICULTY:Difficulty = Difficulty.NORMAL;
	public static var SONG_STAGE:String = '';

	public static var IS_STORYMODE:Bool = false;
	public static var IS_CHARTINGMODE:Bool = false;

	public var vocals:FlxSound;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	public var camFollow:FlxObject;

	public static var prevCamFollow:FlxObject;

	public var camZooming:Bool = false;
	public var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;

	public var generatedMusic:Bool = false;
	public var startingSong:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;

	public static var globalScore:Int = 0;

	public var songScore:Int = 0;

	public var scoreTxt:FlxText;

	public var defaultCamZoom:Float = 1.05;

	public var inCutscene:Bool = false;

	public var currentStage:StageBackground;
	public var songScript:SongClass;

	public var tweenManager:FlxTweenManager = new FlxTweenManager();

	public static var CAMFOLLOWLERP(get, never):Float;

	static function get_CAMFOLLOWLERP():Float
	{
		return 0.04;
	}

	public var strums:StrumsGroup;

	public static var global_resultsData:ResultsData = null;

	public var local_resultsData:ResultsData = null;

	public static var globalComboBreaks:Int = 0;

	public var localComboBreaks:Int = 0;

	override public function create()
	{
		if (instance != null) instance = null;
		instance = this;

		if (!IS_STORYMODE || STORYMODE_PLAYLIST_NUMBER == 0) globalComboBreaks = 0;
		if (!IS_STORYMODE || (global_resultsData == null || STORYMODE_PLAYLIST_NUMBER == 0)) global_resultsData = new ResultsData();
		local_resultsData = new ResultsData();

		if (!IS_STORYMODE || STORYMODE_PLAYLIST_NUMBER == 0) globalScore = 0;
		songScore += globalScore;

		strums = new StrumsGroup();
		add(strums);

		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		@:privateAccess
		FlxCamera._defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null) SONG = Song.loadFromJson('tutorial', 'tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		camFollow = new FlxObject(0, 0, 1, 1);

		currentStage = StageBackground.getStage(SONG);
		add(currentStage);

		songScript = SongClass.getSongClass(SONG.song.toLowerCase());

		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		generateSong(SONG.song);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, CAMFOLLOWLERP);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		// FlxG.fixedTimestep = false;

		initUI();

		EventParser.init();

		strums.cameras = [camHUD];
		notes.cameras = [camHUD];

		startingSong = true;

		var ret:Bool = songScript.preCountdown();
		if (ret) startCountdown();

		super.create();
		songScript.postCreate();
	}

	public var startTimer:FlxTimer;
	public var perfectMode:Bool = #if PERFECTMODE true #else false #end;

	function startCountdown():Void
	{
		inCutscene = false;
		canPause = true;

		generateStaticArrows(false);
		generateStaticArrows(true);

		startedCountdown = true;

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer) {
			currentStage.countdownTick(swagCounter);
			songScript.countdownTick(swagCounter);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', "set", "go"]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			switch (swagCounter)

			{
				case 0:
					FlxG.sound.play(AssetPaths.sound('intro3$altSuffix'), 0.6);
				case 1:
					countdownSprite(introAlts[0]);
					FlxG.sound.play(AssetPaths.sound('intro2$altSuffix'), 0.6);
				case 2:
					countdownSprite(introAlts[1]);
					FlxG.sound.play(AssetPaths.sound('intro1$altSuffix'), 0.6);
				case 3:
					countdownSprite(introAlts[2]);
					FlxG.sound.play(AssetPaths.sound('introGo$altSuffix'), 0.6);
				case 4:
			}

			swagCounter += 1;
		}, 5);
	}

	public function countdownSprite(path:String)
	{
		var spr:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.image(path));
		spr.scrollFactor.set();

		spr.screenCenter();
		add(spr);
		FlxTween.tween(spr, {y: spr.y += 100, alpha: 0}, Conductor.crochet / 1000,
			{
				ease: FlxEase.cubeInOut,
				onComplete: function(twn:FlxTween) {
					remove(spr);
					spr.destroy();
				}
			});
	}

	public var previousFrameTime:Int = 0;
	public var songTime:Float = 0;

	public function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;

		FlxG.sound.playMusic(AssetPaths.song_inst(curSong), 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
		songScript.startSong();

		canPause = true;
	}

	var debugNum:Int = 0;

	public var events:Array<FlxTimer> = [];

	public function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song.toLowerCase();

		if (SONG.needsVoices) vocals = new FlxSound().loadEmbedded(AssetPaths.song_voices(curSong.toLowerCase()));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteID:Array<SwagSection>;

		// NEW SHIT
		noteID = songData.notes;

		var loops:Int = 0;
		for (section in noteID)
		{
			for (event in section.sectionEvents)
			{
				if (event == null) continue;

				var eventTime:Float = event[0];
				var eventName:String = event[1];
				var eventValue:String = event[2];

				events.push(new FlxTimer().start(Math.abs(Conductor.songPosition / 1000) + (eventTime / 1000), function(t) {
					trace('Sending event($eventName, ${eventValue.split(EventParser.splitText)})');
					EventParser.sendEvent(eventName, eventValue);

					songScript.sendEvent(eventName, eventValue.split(EventParser.splitText));
					currentStage.sendEvent(eventName, eventValue.split(EventParser.splitText));

					if (currentStage.dad != null) currentStage.dad.sendEvent(eventName, eventValue.split(EventParser.splitText));
					if (currentStage.gf != null) currentStage.gf.sendEvent(eventName, eventValue.split(EventParser.splitText));
					if (currentStage.boyfriend != null) currentStage.boyfriend.sendEvent(eventName, eventValue.split(EventParser.splitText));
				}));
			}

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var danoteID:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3) gottaHitNote = !section.mustHitSection;

				var oldNote:Note;
				if (unspawnNotes.length > 0) oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, danoteID, oldNote, false, songNotes[3] ?? null);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);
				swagNote.inactive = Note.getIfNoteIsInactive(swagNote, SONG);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if (!swagNote.inactive)
				{
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, danoteID, oldNote, true,
							songNotes[3] ?? null);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						sustainNote.inactive = Note.getIfNoteIsInactive(sustainNote, SONG);

						sustainNote.mustPress = gottaHitNote;

						if (sustainNote.mustPress) sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress) swagNote.x += FlxG.width / 2; // general offset
			}
			loops += 1;
		}

		trace('Event count: ${events.length}');

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
		songScript.generateSong(dataPath);
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public function generateStaticArrows(player:Bool):Void
	{
		for (i in 0...4)
		{
			var babyArrow:StaticNote = new StaticNote(i, 50, STRUMLINE_Y);
			babyArrow.scrollFactor.set();

			babyArrow.y -= 10;
			babyArrow.alpha = 0;

			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			if (player)
			{
				babyArrow.x += FlxG.width / 2;
				strums.playerStrums.add(babyArrow);
			}
			else
			{
				strums.opponentStrums.add(babyArrow);

				babyArrow.anim.onFinish.add((animName:String) -> {
					if (animName == "confirm") babyArrow.playAnim("static");
				});
			}

			babyArrow.playAnim('static');

			songScript.generateStaticArrows(player, i, babyArrow);
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished) startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong) resyncVocals();

			if (!startTimer.finished) startTimer.active = true;
			paused = false;
			songScript.unpause();
			EventParser.unpause();
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		songScript.resyncVocals();
	}

	public var paused:Bool = false;

	public var startedCountdown:Bool = false;
	public var canPause:Bool = false;

	public static var ICON_OFFSET:Int = 13;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		scoreTxt.text = 'Score: $songScore | Combo Breaks: ${globalComboBreaks + localComboBreaks}';

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			EventParser.pause();
			openSubState(new PauseSubState(currentStage.boyfriend?.getScreenPosition().x, currentStage.boyfriend?.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN) FlxG.switchState(() -> new ChartingState());

		var targIconWidth = Std.int(100);
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.width, targIconWidth, .1)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.width, targIconWidth, .1)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.value, 0, 2, 100, 0) * 0.01) - ICON_OFFSET);
		iconP2.x = iconP1.x - iconP2.width;

		if (health > 2) health = 2;

		if (healthBar.percent < 20) iconP1.state = LOSING;
		else
			iconP1.state = NORMAL;

		if (healthBar.percent > 80) iconP2.state = LOSING;
		else
			iconP2.state = NORMAL;

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0) startSong();
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, defaultCamZoom, 0.05);
			camHUD.zoom = FlxMath.lerp(camHUD.zoom, 1, 0.05);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		songScript.update(elapsed);

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		if (health <= 0)
		{
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			if (vocals != null) vocals.stop();
			if (FlxG.sound.music != null) FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(currentStage.boyfriend?.getScreenPosition().x, currentStage.boyfriend?.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.y > FlxG.height) daNote.active = daNote.visible = false;
				else
					daNote.visible = daNote.active = true;

				daNote.y = (STRUMLINE_Y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= STRUMLINE_Y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					var swagRect = new FlxRect(0, STRUMLINE_Y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[curSection] != null) if (SONG.notes[curSection].altAnim) altAnim = '-alt';

					if (altAnim == "") altAnim = Note.getAlt(daNote, SONG);

					var ret:Bool = songScript.opNoteHit(daNote);

					if (ret)
					{
						currentStage.makeCharacterSing(daNote, currentStage.dad, false, altAnim);
						if (currentStage.dad != null) currentStage.dad.holdTimer = 0;

						if (SONG.needsVoices) vocals.volume = 1;

						strums.opponentStrums.forEach(function(spr:FunkinSprite) {
							if (Math.abs(daNote.noteID) == spr.ID) spr.playAnim('confirm');
						});
					}

					endNote(daNote);
				}

				if (daNote.y < -daNote.height)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						endNote(daNote);
					}
					else
					{
						if (daNote.tooLate || !daNote.wasGoodHit) badNoteHit(daNote.noteID);

						daNote.active = false;
						daNote.visible = false;

						endNote(daNote);
					}
				}
			});
		}

		if (!inCutscene) keyShit();

		#if ONE_ENDSONG_KEY
		if (FlxG.keys.justPressed.ONE) endSong();
		#end
	}

	public function endNote(daNote:Note)
	{
		daNote.kill();
		notes.remove(daNote, true);
		daNote.destroy();
	}

	function endSong():Void
	{
		var ret:Bool = songScript.endSong();
		if (!ret) return;

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.volume = 0;
			vocals.volume = 0;

			FlxG.sound.music.stop();
			vocals.stop();
		}

		global_resultsData.notesMissed += local_resultsData.notesMissed;
		global_resultsData.totalNotesHit += local_resultsData.totalNotesHit;
		for (key => value in local_resultsData.noteRatingCounts)
		{
			global_resultsData.noteRatingCounts.set(key, global_resultsData.noteRatingCounts.get(key) + value);
		}
		trace('local results data: ${local_resultsData}');
		trace('global results data: ${global_resultsData}');

		globalScore += songScore;
		globalComboBreaks += localComboBreaks;

		persistentUpdate = false;
		persistentDraw = true;
		paused = true;
		canPause = false;

		songScript.pause();

		if (IS_CHARTINGMODE)
		{
			FlxG.switchState(() -> new ChartingState());
			return;
		}

		Highscore.saveScore(curSong.toLowerCase(), songScore, SONG_DIFFICULTY);
		if (IS_STORYMODE)
		{
			if (STORYMODE_PLAYLIST.length > 0) STORYMODE_PLAYLIST.remove(SONG.song);

			if (STORYMODE_PLAYLIST.length > 0)
			{
				/**
					Load the next
					story mode song chart
				**/
				var nextSong = STORYMODE_PLAYLIST[0].toLowerCase();
				var nextChart = Highscore.formatToDifficulty(nextSong, SONG_DIFFICULTY);

				loadSong(nextChart, nextSong, SONG_DIFFICULTY, IS_CHARTINGMODE, IS_STORYMODE);

				STORYMODE_PLAYLIST_NUMBER++;
				trace('Moving to next song: ${nextSong}');

				FlxG.switchState(() -> new PlayState());
			}
			else
			{
				Highscore.saveScore(STORYMODE_WEEK.toLowerCase(), globalScore, SONG_DIFFICULTY);
				openSubState(new ResultsSubState((() -> new StoryModeState())));

				STORYMODE_PLAYLIST_NUMBER = 0;
				STORYMODE_PLAYLIST = [];
				STORYMODE_WEEK = '';
			}
		}
		else
			openSubState(new ResultsSubState((() -> new FreeplayState())));
	}

	var endingSong:Bool = false;

	public function popUpScore(strumtime:Float):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 50;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.75)
		{
			daRating = 'bad';
			score = 100;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.2)
		{
			daRating = 'good';
			score = 200;
		}

		local_resultsData.earnRating(daRating);

		songScore += score;

		rating.loadGraphic(AssetPaths.image(daRating));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.updateHitbox();

		if (combo >= 10 || combo == 0)
		{
			add(new ComboNumbers(combo, coolText.x, (cn) -> {
				remove(cn);
				cn.destroy();
			}));
		}

		add(rating);
		FlxTween.tween(rating, {alpha: 0}, 0.2,
			{
				startDelay: Conductor.crochet * 0.001
			});

		songScript.popUpScore(strumtime);
	}

	public function keyShit():Void
	{
		// control arrays, order L D R U
		var holdArray:Array<Bool> = [controls.NOTE_LEFT, controls.NOTE_DOWN, controls.NOTE_UP, controls.NOTE_RIGHT];
		var pressArray:Array<Bool> = [
			controls.NOTE_LEFT_P,
			controls.NOTE_DOWN_P,
			controls.NOTE_UP_P,
			controls.NOTE_RIGHT_P
		];
		var releaseArray:Array<Bool> = [
			controls.NOTE_LEFT_R,
			controls.NOTE_DOWN_R,
			controls.NOTE_UP_R,
			controls.NOTE_RIGHT_R
		];

		// HOLDS, check for sustain notes
		if (holdArray.contains(true) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteID]) goodNoteHit(daNote);
			});
		}

		// PRESSES, check for note hits
		if (pressArray.contains(true) && generatedMusic)
		{
			if (currentStage.boyfriend != null) currentStage.boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later

			notes.forEachAlive(function(daNote:Note) {
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					if (directionList.contains(daNote.noteID))
					{
						for (coolNote in possibleNotes)
						{
							if (coolNote.noteID == daNote.noteID && Math.abs(daNote.strumTime - coolNote.strumTime) < 10)
							{ // if it's the same note twice at < 10ms distance, just delete it
								// EXCEPT u cant delete it in this loop cuz it fucks with the collection lol
								dumbNotes.push(daNote);
								break;
							}
							else if (coolNote.noteID == daNote.noteID && daNote.strumTime < coolNote.strumTime)
							{ // if daNote is earlier than existing note (coolNote), replace
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}
					else
					{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteID);
					}
				}
			});

			for (note in dumbNotes)
			{
				FlxG.log.add("killing dumb ass note at " + note.strumTime);
				endNote(note);
			}

			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

			if (perfectMode) goodNoteHit(possibleNotes[0]);
			else if (possibleNotes.length > 0)
			{
				// if a direction is hit that shouldn't be
				for (shit in 0...pressArray.length)
					if (pressArray[shit] && !directionList.contains(shit)) badNoteHit(shit);
				for (coolNote in possibleNotes)
					if (pressArray[coolNote.noteID]) goodNoteHit(coolNote);
			}
			else
				for (shit in 0...pressArray.length)
					if (pressArray[shit]) ghostNoteHit(shit);
		}

		if (currentStage.boyfriend?.holdTimer > Conductor.stepCrochet * currentStage.boyfriend.dadVar * 0.001
			&& !holdArray.contains(true)) if (currentStage.boyfriend?.anim.name.startsWith('sing')
				&& !currentStage.boyfriend?.anim.name.endsWith('miss')) currentStage.boyfriend.playAnim('idle');

		strums.playerStrums.forEach(function(spr:FunkinSprite) {
			if (pressArray[spr.ID] && spr.animation.curAnim.name != 'confirm') spr.playAnim('pressed');
			if (!holdArray[spr.ID]) spr.playAnim('static');
		});
		songScript.keyShit();
	}

	/**
		This is what happens with
		ALL note misses n shit
	**/
	function generalNoteMiss(direction:Int = 1):Void
	{
		FlxG.sound.play(AssetPaths.sound('missnote${FlxG.random.int(1, 3)}'), FlxG.random.float(0.1, 0.2));

		currentStage.makeCharacterSing(new Note(0, direction, null, false), currentStage.boyfriend, true);
		songScript.generalNoteMiss(direction);
	}

	/**
		Hit a note when there
		are NO NOTES.
	**/
	function ghostNoteHit(direction:Int):Void
	{
		if (Save.preferences.get().ghostTapping) return;

		health -= 0.08;
		songScore -= 5;

		FlxG.log.add('ghost');

		generalNoteMiss(direction);
		songScript.ghostNoteHit(direction);
	}

	/**
		Hit a note that isn't there
		when there ARE nots near
	**/
	function badNoteHit(direction:Int):Void
	{
		health -= 0.04;
		songScore -= 10;

		if (currentStage.gf != null) if (combo > 5) currentStage.gf.playAnim('sad');

		if (combo > 0)
		{
			combo = 0;
			localComboBreaks++;
		}
		local_resultsData.notesMissed++;

		vocals.volume = 0;

		FlxG.log.add('non-ghost');

		generalNoteMiss(direction);
		songScript.badNoteHit(direction);
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				#if COMBO_10X
				if (combo > 0) combo *= 10;
				else
				#end
				combo += 1;
				local_resultsData.totalNotesHit++;
			}

			if (note.noteID >= 0) health += 0.023;
			else
				health += 0.004;

			var altAnim:String = "";

			if (SONG.notes[curSection] != null) if (SONG.notes[curSection].altAnim) altAnim = '-alt';
			if (altAnim == "") altAnim = Note.getAlt(note, SONG);

			var ret:Bool = songScript.playerNoteHit(note);

			if (ret)
			{
				currentStage.makeCharacterSing(note, currentStage.boyfriend, false, altAnim);

				strums.playerStrums.forEach(function(spr:FunkinSprite) {
					if (Math.abs(note.noteID) == spr.ID) spr.playAnim('confirm', true);
				});

				note.wasGoodHit = true;
				vocals.volume = 1;
			}

			if (!note.isSustainNote) endNote(note);
		}
	}

	override function stepHit()
	{
		super.stepHit();
		if (SONG.needsVoices) if (vocals.time > Conductor.songPosition + 20 || vocals.time < Conductor.songPosition - 20) resyncVocals();
		currentStage.stepHit(curStep);
		songScript.stepHit(curStep);
	}

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic) notes.sort(FlxSort.byY, FlxSort.DESCENDING);

		if (SONG.notes[curSection] != null)
		{
			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[curSection].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			// Dad doesnt interupt his own notes
			if (SONG.notes[curSection].mustHitSection) currentStage.dad?.dance();
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (currentStage.gf != null) if (curBeat % gfSpeed == 0) currentStage.gf.dance();

		if (!currentStage.boyfriend?.anim.name?.startsWith("sing")) currentStage.boyfriend?.playAnim('idle');

		currentStage.beatHit(curBeat);
		songScript.beatHit(curBeat);
	}

	override function sectionHit()
	{
		if (PlayState.SONG.notes[curSection] != null)
		{
			currentStage.sectionHit(curSection);
			songScript.sectionHit(curSection);
		}

		if (generatedMusic && PlayState.SONG.notes[curSection] != null)
		{
			var ret:Bool = songScript.moveCamera(PlayState.SONG.notes[curSection].mustHitSection);

			if (!ret) return;

			if (!PlayState.SONG.notes[curSection].mustHitSection) camFollow.setPosition(currentStage.dad?.getMidpoint().x + 150,
				currentStage.dad?.getMidpoint().y - 100);

			if (PlayState.SONG.notes[curSection].mustHitSection) camFollow.setPosition(currentStage.boyfriend?.getMidpoint().x - 100,
				currentStage.boyfriend?.getMidpoint().y - 100);
			currentStage.moveCamera(PlayState.SONG.notes[curSection].mustHitSection);
		}
	}

	public var healthBar_emptyColor:FlxColor = 0xFFFF0000;
	public var healthBar_fillColor:FlxColor = 0xFF66FF33;

	public function initUI()
	{
		var ret:Bool = songScript.initUI();
		if (!ret) return;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(AssetPaths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		if (Save.preferences.get().downScroll) healthBarBG.y = FlxG.height - healthBarBG.y;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(healthBar_emptyColor, healthBar_fillColor);
		add(healthBar);

		iconP1 = new HealthIcon(currentStage?.boyfriend?.iconChar, true);
		if (currentStage.boyfriend != null) add(iconP1);

		iconP2 = new HealthIcon(currentStage?.dad?.iconChar, false);
		if (currentStage.dad != null) add(iconP2);

		var p1Adjust = (iconP1.height / 2);
		var p2Adjust = (iconP2.height / 2);

		iconP1.y = healthBar.y - p1Adjust;
		iconP2.y = healthBar.y - p2Adjust;

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 16);
		scoreTxt.setFormat(AssetPaths.font('vcr.ttf'), 16, FlxColor.WHITE, RIGHT);
		scoreTxt.scrollFactor.set();
		scoreTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		add(scoreTxt);

		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
	}
}
