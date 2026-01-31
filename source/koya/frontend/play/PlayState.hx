package koya.frontend.play;

import koya.frontend.mainmenu.MainMenuState;
import koya.frontend.play.songs.SongClass;
import koya.frontend.freeplay.FreeplayState;
import koya.backend.play.Difficulty;
import koya.frontend.play.stages.StageBackground;
import koya.frontend.play.characters.*;
import koya.frontend.play.editors.ChartingState;
import koya.backend.*;
import koya.backend.Section.SwagSection;
import koya.backend.songs.Song;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUMLINE_Y:Float = 50.0;

	public static var instance:PlayState = null;

	public static var SONG:SwagSong;
	public static var SONG_DIFFICULTY:Int = Difficulty.NORMAL;
	public static var SONG_STAGE:String = '';

	public static var storyMode:Bool = false;
	public static var chartingMode:Bool = false;

	public var vocals:FlxSound;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];

	public var camFollow:FlxObject;

	public static var prevCamFollow:FlxObject;

	public var opponentStrums:FlxTypedGroup<FunkinSprite>;
	public var playerStrums:FlxTypedGroup<FunkinSprite>;

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

	public var songScore:Int = 0;
	public var scoreTxt:FlxText;

	public static var campaignScore:Int = 0;

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

	override public function create()
	{
		if (instance != null) instance = null;
		instance = this;

		// var gameCam:FlxCamera = FlxG.camera;
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

		opponentStrums = new FlxTypedGroup<FunkinSprite>();
		add(opponentStrums);

		playerStrums = new FlxTypedGroup<FunkinSprite>();
		add(playerStrums);

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

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(AssetPaths.image('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		add(healthBar);

		iconP1 = new HealthIcon(currentStage?.boyfriend?.iconChar, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		if (currentStage.boyfriend != null) add(iconP1);

		iconP2 = new HealthIcon(currentStage?.dad?.iconChar, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		if (currentStage.dad != null) add(iconP2);

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 190, healthBarBG.y + 30, 0, "", 16);
		scoreTxt.setFormat(AssetPaths.font('vcr.ttf'), 16, FlxColor.WHITE, RIGHT);
		scoreTxt.scrollFactor.set();
		scoreTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		scoreTxt.antialiasing = false;
		add(scoreTxt);

		opponentStrums.cameras = [camHUD];
		playerStrums.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		startingSong = true;

		var ret:Bool = songScript.preCountdown();
		if (ret) startCountdown();

		super.create();
		songScript.postCreate();
	}

	public var startTimer:FlxTimer;
	public var perfectMode:Bool = #if BOTPLAY true #else false #end;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(false);
		generateStaticArrows(true);

		startedCountdown = true;

		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

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

		if (!paused) FlxG.sound.playMusic(AssetPaths.song_inst(curSong), 1, false);

		FlxG.sound.music.onComplete = endSong;
		vocals.play();
		songScript.startSong();
	}

	var debugNum:Int = 0;

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

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteID)
		{
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

				var swagNote:Note = new Note(daStrumTime, danoteID, oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);
				swagNote.noteData = songNotes[4] ?? null;
				swagNote.inactive = swagNote.noteData != null;

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if (!swagNote.inactive)
				{
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, danoteID, oldNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);

						sustainNote.mustPress = gottaHitNote;

						if (sustainNote.mustPress) sustainNote.x += FlxG.width / 2; // general offset
					}
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress) swagNote.x += FlxG.width / 2; // general offset
			}
			daBeats += 1;
		}

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
				playerStrums.add(babyArrow);
			}
			else
			{
				opponentStrums.add(babyArrow);

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
	public var canPause:Bool = true;

	public static var ICON_OFFSET:Int = 13;

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		scoreTxt.text = "Score:" + songScore;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(currentStage.boyfriend?.getScreenPosition().x, currentStage.boyfriend?.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN) FlxG.switchState(() -> new ChartingState());

		var targIconWidth = Std.int(100);
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(targIconWidth, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(targIconWidth, iconP2.width, 0.50)));

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
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		if (health <= 0)
		{
			if (currentStage.boyfriend != null) currentStage.boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

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
					if (curSong != 'tutorial') camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null) if (SONG.notes[Math.floor(curStep / 16)].altAnim) altAnim = '-alt';

					currentStage.makeCharacterSing(daNote, currentStage.dad, false, altAnim);

					if (currentStage.dad != null) currentStage.dad.holdTimer = 0;

					opponentStrums.forEach(function(spr:FunkinSprite) {
						if (Math.abs(daNote.noteID) == spr.ID) spr.playAnim('confirm');
					});

					if (SONG.needsVoices) vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (STRUMLINE_Y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height)
				{
					if (daNote.isSustainNote && daNote.wasGoodHit)
					{
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
					else
					{
						if (daNote.tooLate || !daNote.wasGoodHit)
						{
							health -= 0.0475;
							vocals.volume = 0;
						}

						daNote.active = false;
						daNote.visible = false;

						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}
			});
		}

		if (!inCutscene) keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE) endSong();
		#end

		songScript.update(elapsed);
	}

	function endSong():Void
	{
		var ret:Bool = songScript.endSong();

		if (!ret) return;

		canPause = false;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;

		Highscore.saveScore(curSong.toLowerCase(), songScore, SONG_DIFFICULTY);

		if (chartingMode)
		{
			FlxG.switchState(() -> new ChartingState());
			return;
		}

		if (storyMode)
		{
			FlxG.switchState(() -> new MainMenuState());
		}
		else
			FlxG.switchState(() -> new FreeplayState());
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

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.image('num${Std.int(i)}'));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0) add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2,
				{
					onComplete: function(tween:FlxTween) {
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});

			daLoop++;
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
		// HOLDING
		var up = controls.NOTE_UP;
		var right = controls.NOTE_RIGHT;
		var down = controls.NOTE_DOWN;
		var left = controls.NOTE_LEFT;

		var upP = controls.NOTE_UP_P;
		var rightP = controls.NOTE_RIGHT_P;
		var downP = controls.NOTE_DOWN_P;
		var leftP = controls.NOTE_LEFT_P;

		var upR = controls.NOTE_UP_R;
		var rightR = controls.NOTE_RIGHT_R;
		var downR = controls.NOTE_DOWN_R;
		var leftR = controls.NOTE_LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if (controlArray.contains(true) && !currentStage.boyfriend?.stunned && generatedMusic)
		{
			if (currentStage.boyfriend != null) currentStage.boyfriend.holdTimer = 0;

			var possibleNotes:Array<Note> = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note) {
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate)
				{
					// the sorting probably doesn't need to be in here? who cares lol
					possibleNotes.push(daNote);
					possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

					ignoreList.push(daNote.noteID);
				}
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode) noteCheck(true, daNote);

				// Jump notes
				if (possibleNotes.length >= 2)
				{
					if (possibleNotes[0].strumTime == possibleNotes[1].strumTime)
					{
						for (coolNote in possibleNotes)
							if (controlArray[coolNote.noteID] || perfectMode) goodNoteHit(coolNote);
							else
							{
								var inIgnoreList:Bool = false;
								for (shit in 0...ignoreList.length)
									if (controlArray[ignoreList[shit]]) inIgnoreList = true;

								if (!inIgnoreList && !daNote.inactive) badNoteCheck();
							}
					}
					else if (possibleNotes[0].noteID == possibleNotes[1].noteID) noteCheck(controlArray[daNote.noteID], daNote);
					else
						for (coolNote in possibleNotes)
							noteCheck(controlArray[coolNote.noteID], coolNote);
				}
				else // regular notes?
					noteCheck(controlArray[daNote.noteID], daNote);

				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else
				badNoteCheck();
		}

		if ((up || right || down || left) && !currentStage.boyfriend?.stunned && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote) switch (daNote.noteID)
				{
					case 0:
						if (left) goodNoteHit(daNote);
					case 1:
						if (down) goodNoteHit(daNote);
					case 2:
						if (up) goodNoteHit(daNote);
					case 3:
						if (right) goodNoteHit(daNote);
				}
			});
		}

		if (currentStage.boyfriend?.holdTimer > Conductor.stepCrochet * currentStage.boyfriend?.dadVar * 0.001
			&& !up
			&& !down
			&& !right
			&& !left) if (currentStage.boyfriend?.anim.name?.startsWith('sing')
				&& !currentStage.boyfriend?.anim.name?.endsWith('miss')) currentStage.boyfriend?.playAnim('idle');

		playerStrums.forEach(function(spr:FunkinSprite) {
			var dirP = false;
			var dirR = false;

			switch (spr.ID)
			{
				case 0:
					dirP = leftP;
					dirR = leftR;
				case 1:
					dirP = downP;
					dirR = downR;
				case 2:
					dirP = upP;
					dirR = upR;
				case 3:
					dirP = rightP;
					dirR = rightR;
			}

			if (dirP && spr.anim.name != 'confirm') spr.playAnim('pressed');
			if (dirR) spr.playAnim('static');
		});

		songScript.keyShit();
	}

	function noteMiss(direction:Int = 1):Void
	{
		if (!currentStage.boyfriend?.stunned ?? true)
		{
			health -= 0.04;
			if (currentStage.gf != null) if (combo > 5) currentStage.gf.playAnim('sad');
			combo = 0;

			songScore -= 10;

			FlxG.sound.play(AssetPaths.sound('missnote${FlxG.random.int(1, 3)}'), FlxG.random.float(0.1, 0.2));

			if (currentStage.boyfriend != null) currentStage.boyfriend.stunned = true;

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer) {
				if (currentStage.boyfriend != null) currentStage.boyfriend.stunned = false;
			});

			currentStage.makeCharacterSing(new Note(0, direction, null, false), currentStage.boyfriend, true);
			songScript.noteMiss(direction);
		}
	}

	function badNoteCheck()
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		var upP = controls.NOTE_UP_P;
		var rightP = controls.NOTE_RIGHT_P;
		var downP = controls.NOTE_DOWN_P;
		var leftP = controls.NOTE_LEFT_P;

		if (leftP) noteMiss(0);
		if (downP) noteMiss(1);
		if (upP) noteMiss(2);
		if (rightP) noteMiss(3);
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP) goodNoteHit(note);
		else
			badNoteCheck();
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime);
				combo += 1;
			}

			if (note.noteID >= 0) health += 0.023;
			else
				health += 0.004;

			var altAnim:String = "";

			if (SONG.notes[Math.floor(curStep / 16)] != null) if (SONG.notes[Math.floor(curStep / 16)].altAnim) altAnim = '-alt';

			currentStage.makeCharacterSing(note, currentStage.boyfriend, false, altAnim);

			playerStrums.forEach(function(spr:FunkinSprite) {
				if (Math.abs(note.noteID) == spr.ID) spr.playAnim('confirm', true);
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}

			songScript.goodNoteHit(note);
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

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			// Dad doesnt interupt his own notes
			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection) currentStage.dad?.dance();
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

			if (ret)
			{
				if (!PlayState.SONG.notes[curSection].mustHitSection) camFollow.setPosition(currentStage.dad?.getMidpoint().x + 150,
					currentStage.dad?.getMidpoint().y - 100);

				if (PlayState.SONG.notes[curSection].mustHitSection) camFollow.setPosition(currentStage.boyfriend?.getMidpoint().x - 100,
					currentStage.boyfriend?.getMidpoint().y - 100);
				currentStage.moveCamera(PlayState.SONG.notes[curSection].mustHitSection);
			}
		}
	}
}
