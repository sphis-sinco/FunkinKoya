package koya.frontend.scenes.play.scenes.editors;

import flixel.util.FlxSort;
import koya.backend.plugins.Cursor;
import koya.backend.songs.SongList;
import koya.backend.play.Difficulty;
import koya.backend.save.Save;
import koya.backend.songs.Section;
import koya.backend.songs.Song;
import koya.backend.*;
import koya.backend.Conductor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import koya.backend.KoyaAssets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;

using StringTools;

class ChartingState extends MusicBeatState
{
	var _file:FileReference;

	var Main_UI:FlxUITabMenu;
	var Event_UI:FlxUITabMenu;

	public static var lastSection:Int = 0;

	var bpmTxt:FlxText;

	var strumLine:FlxSprite;
	var curSong:String = '';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;

	var highlight:FlxSprite;

	var GRID_SIZE:Int = 40;

	var dummyArrow:FlxSprite;

	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedEvents:FlxTypedGroup<FunkinSprite>;
	var curRenderedEventTexts:FlxTypedGroup<FlxText>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;

	var gridBG:FlxSprite;

	var _song:SwagSong;

	var typingShit:FlxInputText;
	/*
	 * WILL BE THE CURRENT / LAST PLACED NOTE
	**/
	var curSelectedNote:Array<Dynamic>;

	var tempBpm:Float = 0;

	var vocals:FlxSound;

	var leftIcon:HealthIcon;
	var rightIcon:HealthIcon;

	public function makeBPMText()
	{
		var songPos = FlxMath.roundDecimal(Conductor.songPosition / 1000, 2);
		var songLen = FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2);

		bpmTxt.text = '';

		bpmTxt.text += 'Time: ${songPos}s / ${songLen}s\n';
		bpmTxt.text += 'Beat: ${(curBeat < 0) ? 0 : curBeat}\n';
		bpmTxt.text += 'Step: ${(curStep < 0) ? 0 : curStep}\n';
		bpmTxt.text += 'Section: ${curSection}\n';

		bpmTxt.x = 20;
		bpmTxt.y = 20;
		if (Main.WATERMARK != null) bpmTxt.y += (Main.WATERMARK.height / 2) + Main.WATERMARK.y;
	}

	override function create()
	{
		curSection = lastSection;

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
		add(gridBG);

		leftIcon = new HealthIcon('bf');
		rightIcon = new HealthIcon('dad');
		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.setGraphicSize(0, 45);
		rightIcon.setGraphicSize(0, 45);

		add(leftIcon);
		add(rightIcon);

		leftIcon.setPosition(0, -100);
		rightIcon.setPosition(gridBG.width / 2, -100);

		var gridBlackLine:FlxSprite = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedEvents = new FlxTypedGroup<FunkinSprite>();
		curRenderedEventTexts = new FlxTypedGroup<FlxText>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

		if (PlayState.SONG != null) _song = PlayState.SONG;
		else
			_song = Song.dummySong;

		Song.fixSwagVersion(_song);

		trace(_song.song);
		curSong = _song.song.toLowerCase();
		tempBpm = _song.bpm;

		addSection();

		// sections = _song.notes;

		bpmTxt = new FlxText(1000, 50, 0, "", 16);
		bpmTxt.scrollFactor.set();
		add(bpmTxt);

		strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(gridBG.width), 4);
		add(strumLine);
		FlxG.camera.follow(strumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		var main_tabs = [
			{name: "Song", label: 'Song'},
			{name: "Song2", label: 'Song (Part 2)'},
			{name: "Section", label: 'Section'},
			{name: "Note", label: 'Note'}
		];

		var event_tabs = [
			{name: "Event", label: 'Event'}];

		Main_UI = new FlxUITabMenu(null, main_tabs, true);

		Main_UI.resize(450, 400);
		Main_UI.x = FlxG.width - (Main_UI.width + 20);
		Main_UI.y = 20;
		add(Main_UI);
		Main_UI.scrollFactor.set();

		Event_UI = new FlxUITabMenu(null, event_tabs, true);

		Event_UI.resize(Main_UI.width, 200);
		Event_UI.x = Main_UI.x;
		Event_UI.y = Main_UI.y + Main_UI.height + 20;

		add(Event_UI);
		Event_UI.scrollFactor.set();

		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		addSongUI();
		addSongPart2UI();
		addSectionUI();
		addNoteUI();

		addEventUI();

		add(curRenderedNotes);
		add(curRenderedSustains);
		add(curRenderedEvents);
		add(curRenderedEventTexts);

		super.create();

		Cursor.cursorVisible = true;

		updateGrid();

		FlxG.sound.music.pause();
		FlxG.sound.music.time = 0;
	}

	var eventValue:FlxUIInputText;
	var eventDropDown:FlxUIInputText;

	function addEventUI():Void
	{
		var tab_group = new FlxUI(null, Event_UI);
		tab_group.name = "Event";

		Event_UI.addGroup(tab_group);

		eventDropDown = new FlxUIInputText(10, 20, Std.int(Event_UI.width - 20), '', 8);
		tab_group.add(new FlxText(eventDropDown.x, eventDropDown.y - 16, 0, 'Event Name', 8));
		tab_group.add(eventDropDown);

		eventValue = new FlxUIInputText(10, 60, Std.int(Event_UI.width - 20), '', 8);
		tab_group.add(new FlxText(eventValue.x, eventValue.y - 16, 0, 'Event Value (arrayFormat/split by/these things)', 8));
		tab_group.add(eventValue);

		var addButton:FlxButton = new FlxButton(10, 100, "Add Event", function() {
			addEvent();
		});
		tab_group.add(addButton);

		var removeButton:FlxButton = new FlxButton(130, 100, "Remove Event", function() {
			removeEvent();
		});
		tab_group.add(removeButton);
	}

	public var eventRangeValue:Float = 40; // this should be in milliseconds right?

	public function removeEvent()
	{
		var eventTime = getStrumTime(strumLine.y) + sectionStartTime();

		var i = 0;
		for (j in 0..._song.notes[curSection].sectionEvents.length)
		{
			// trace(_song.notes[curSection].sectionEvents[j]);
			var eventVal:Dynamic = _song.notes[curSection].sectionEvents[j];
			if (eventVal == null) return;

			var eventValTime = eventVal[0];

			var minCheck = eventValTime > (eventTime - eventRangeValue);
			var maxCheck = eventValTime < (eventTime + eventRangeValue);

			if (minCheck && maxCheck)
			{
				i++;
				_song.notes[curSection].sectionEvents.remove(eventVal);
			}
		}

		if (i > 0) modifMade('Removed $i event(s) from range : ${eventTime - eventRangeValue} - ${eventTime + eventRangeValue}');
		updateGrid();
	}

	public function addEvent()
	{
		var eventTime = getStrumTime(strumLine.y) + sectionStartTime();
		var eventName = eventDropDown.text.toLowerCase();
		var eventValue = eventValue.text;

		if (eventName.trim() == '') return;
		if (eventValue.trim() == '') return;

		var event:Array<Dynamic> = [eventTime, eventName, eventValue];
		var addEvent:Bool = true;

		for (j in 0..._song.notes[curSection].sectionEvents.length)
		{
			// trace(_song.notes[curSection].sectionEvents[j]);
			var eventVal:Dynamic = _song.notes[curSection].sectionEvents[j];
			var eventValTime = eventVal[0];

			var minCheck = eventValTime > (eventTime - eventRangeValue);
			var maxCheck = eventValTime < (eventTime + eventRangeValue);

			if (minCheck && maxCheck) addEvent = false;
		}

		if (addEvent)
		{
			_song.notes[curSection].sectionEvents.push(event);

			modifMade('Added event($event)');
		}

		updateGrid();
	}

	var characters:Array<String> = CoolUtil.coolTextFile(AssetPaths.txt('data/characterList', 'characters'));
	var stages:Array<String> = CoolUtil.coolTextFile(AssetPaths.txt('data/stageList', 'backgrounds'));

	function addSongUI():Void
	{
		UI_songTitle = new FlxUIInputText(10, 24, 70, _song.song, 8);
		typingShit = UI_songTitle;

		var check_voices = new FlxUICheckBox(UI_songTitle.x, UI_songTitle.y + 20, null, null, "Has voice track", 100);
		check_voices.checked = _song.needsVoices;
		// _song.needsVoices = check_voices.checked;
		check_voices.callback = function() {
			_song.needsVoices = check_voices.checked;
			modifMade('Has voice track');
		};

		var check_mute_inst = new FlxUICheckBox(check_voices.x + check_voices.width + 20, check_voices.y, null, null, "Mute Instrumental (in editor)", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function() {
			var vol:Float = 1;

			if (check_mute_inst.checked) vol = 0;

			FlxG.sound.music.volume = vol;
		};

		var saveButton:FlxButton = new FlxButton(0, 8, "Save", function() {
			saveLevel();
		});
		saveButton.x = Main_UI.width - ((saveButton.width * 2) + 20);

		var reloadSong:FlxButton = new FlxButton(saveButton.x + saveButton.width + 10, saveButton.y, "Reload Audio", function() {
			loadSong(_song.song);
		});

		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, saveButton.y + 30, "Reload JSON", function() {
			loadJson(_song.song.toLowerCase(), Highscore.formatToDifficulty(_song.song.toLowerCase(), _song.difficulty));
		});

		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'load autosave', loadAutosave);

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(check_voices.x, check_voices.y + 30, 1, 1, 1, 339, 0);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';

		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(stepperBPM.x + (stepperBPM.width * 2) + 30, stepperBPM.y, 0.1, 1, 0.1, 10, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';

		var player1DropDown = new FlxUIDropDownMenu(stepperBPM.x, stepperBPM.y + 48, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true),
			function(character:String) {
				_song.player1 = characters[Std.parseInt(character)];
				modifMade('Player Character');
			});
		player1DropDown.selectedLabel = _song.player1;

		var player2DropDown = new FlxUIDropDownMenu(player1DropDown.x + player1DropDown.width + 16, player1DropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String) {
				_song.player2 = characters[Std.parseInt(character)];
				modifMade('Opponent Character');
		});

		player2DropDown.selectedLabel = _song.player2;

		var difficultyDropDown = new FlxUIDropDownMenu(player2DropDown.x + player2DropDown.width + 16, player2DropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(Difficulty.stringList, true), function(difficulty:String) {
				_song.difficulty = Difficulty.list[Std.parseInt(difficulty)];
				modifMade('Song Difficulty');
		});

		difficultyDropDown.selectedLabel = Difficulty.stringList[(_song?.difficulty ?? Song.dummySong.difficulty).toInt()];

		var tab_group_song = new FlxUI(null, Main_UI);
		tab_group_song.name = "Song";
		tab_group_song.add(new FlxText(UI_songTitle.x, UI_songTitle.y - UI_songTitle.height - 4, 0, "Song Name", 8));
		tab_group_song.add(UI_songTitle);

		tab_group_song.add(check_voices);
		tab_group_song.add(check_mute_inst);
		tab_group_song.add(saveButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);

		tab_group_song.add(new FlxText(stepperBPM.x + stepperBPM.width + 4, stepperBPM.y, 0, "Song BPM", 8));
		tab_group_song.add(stepperBPM);
		tab_group_song.add(new FlxText(stepperSpeed.x + stepperSpeed.width + 4, stepperSpeed.y, 0, "Song Speed", 8));
		tab_group_song.add(stepperSpeed);

		tab_group_song.add(new FlxText(player1DropDown.x, player1DropDown.y - 16, 0, "Player Character", 8));
		tab_group_song.add(player1DropDown);
		tab_group_song.add(new FlxText(player2DropDown.x, player2DropDown.y - 16, 0, "Opponent Character", 8));
		tab_group_song.add(player2DropDown);
		tab_group_song.add(new FlxText(difficultyDropDown.x, difficultyDropDown.y - 16, 0, "Song Difficulty", 8));
		tab_group_song.add(difficultyDropDown);

		Main_UI.addGroup(tab_group_song);
	}

	var UI_songTitle:FlxUIInputText;
	var UI_songAuthors:FlxUIInputText;

	var songList:Array<SwagSong> = [];

	function addSongPart2UI():Void
	{
		UI_songAuthors = new FlxUIInputText(10, 24, Std.int(Main_UI.width - 20), _song.authors ?? 'Unknown', 8);
		typingShit = UI_songAuthors;

		var gfVersionDropDown = new FlxUIDropDownMenu(UI_songAuthors.x, UI_songAuthors.y + UI_songAuthors.height + 20,
			FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String) {
				_song.gfVersion = characters[Std.parseInt(character)];
				modifMade('Damsel Version');
		});

		gfVersionDropDown.selectedLabel = _song?.gfVersion ?? Song.dummySong.gfVersion;

		var stageDropDown = new FlxUIDropDownMenu(gfVersionDropDown.x + gfVersionDropDown.width + 16, gfVersionDropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(stages, true), function(stage:String) {
				_song.stage = stages[Std.parseInt(stage)];
				modifMade('Song Stage');
		});

		var songDropDown = new FlxUIDropDownMenu(stageDropDown.x + stageDropDown.width + 16, stageDropDown.y,
			FlxUIDropDownMenu.makeStrIdLabelArray(SongList.stringSongList, true), function(song:String) {
				loadSong(SongList.songList[Std.parseInt(song)].song);
				loadJson(SongList.stringSongList[Std.parseInt(song)],
					Highscore.formatToDifficulty(SongList.stringSongList[Std.parseInt(song)].toLowerCase(), _song.difficulty));
		});

		stageDropDown.selectedLabel = _song?.stage ?? Song.dummySong.stage;

		var tab_group_song = new FlxUI(null, Main_UI);
		tab_group_song.name = "Song2";

		tab_group_song.add(new FlxText(UI_songAuthors.x, UI_songAuthors.y - 16, 0, "Song Composer(s)", 8));
		tab_group_song.add(UI_songAuthors);
		tab_group_song.add(new FlxText(gfVersionDropDown.x, gfVersionDropDown.y - 16, 0, "Damsel (GF) Character", 8));
		tab_group_song.add(gfVersionDropDown);
		tab_group_song.add(new FlxText(stageDropDown.x, stageDropDown.y - 16, 0, "Stage", 8));
		tab_group_song.add(stageDropDown);
		tab_group_song.add(new FlxText(songDropDown.x, songDropDown.y - 16, 0, "Song List", 8));
		tab_group_song.add(songDropDown);

		Main_UI.addGroup(tab_group_song);
	}

	var stepperLength:FlxUINumericStepper;
	var check_mustHitSection:FlxUICheckBox;
	var check_changeBPM:FlxUICheckBox;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;

	function addSectionUI():Void
	{
		var tab_group_section = new FlxUI(null, Main_UI);
		tab_group_section.name = 'Section';

		stepperLength = new FlxUINumericStepper(10, 24, 4, 0, 0, 999, 0);
		stepperLength.value = _song.notes[curSection]?.lengthInSteps ?? 16;
		stepperLength.name = "section_length";

		check_mustHitSection = new FlxUICheckBox(stepperLength.x, stepperLength.y + 30, null, null, "Must hit section", 100, [], function() {
			modifMade('Must Hit Section');
		});
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = true;

		check_changeBPM = new FlxUICheckBox(check_mustHitSection.x, check_mustHitSection.y + 30, null, null, 'Change BPM', 100, [], function() {
			modifMade('Change BPM');
		});
		check_changeBPM.name = 'check_changeBPM';

		stepperSectionBPM = new FlxUINumericStepper(check_changeBPM.x + check_changeBPM.width + 20, check_changeBPM.y, 1, Conductor.bpm, 0, 999, 0);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';

		check_altAnim = new FlxUICheckBox(check_changeBPM.x, check_changeBPM.y + 30, null, null, "Alt Animation", 100, [], function() {
			modifMade('Alt Anim');
		});
		check_altAnim.name = 'check_altAnim';

		var stepperCopy:FlxUINumericStepper = null;

		var copyButton:FlxButton = new FlxButton(check_altAnim.x, check_altAnim.y + 30, "Copy last", function() {
			if (stepperCopy != null) copySection(Std.int(stepperCopy.value));
		});

		stepperCopy = new FlxUINumericStepper(stepperSectionBPM.x, copyButton.y, 1, 1, -999, 999, 0);

		var clearSectionButton:FlxButton = new FlxButton(copyButton.x, copyButton.y + 20, "Clear", clearSection);

		var swapSection:FlxButton = new FlxButton(clearSectionButton.x, clearSectionButton.y + 20, "Swap section", function() {
			for (i in 0..._song.notes[curSection].sectionNotes.length)
			{
				var note = _song.notes[curSection].sectionNotes[i];
				note[1] = (note[1] + 4) % 8;
				_song.notes[curSection].sectionNotes[i] = note;
				updateGrid();
			}
			modifMade('Swap Section');
		});

		tab_group_section.add(new FlxText(stepperLength.x, stepperLength.y - 16, 0, 'Section Length', 8));
		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(check_mustHitSection);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(swapSection);

		Main_UI.addGroup(tab_group_section);
	}

	var stepperSusLength:FlxUINumericStepper;
	var UI_note:FlxUIInputText;

	function addNoteUI():Void
	{
		var tab_group_note = new FlxUI(null, Main_UI);
		tab_group_note.name = 'Note';

		stepperSusLength = new FlxUINumericStepper(10, 24, Conductor.stepCrochet / 2, 0, 0, Conductor.stepCrochet * 16);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';

		UI_note = new FlxUIInputText(stepperSusLength.x, stepperSusLength.y + stepperSusLength.height + 32, Std.int(Main_UI.width - 20), '', 8);
		typingShit = UI_note;

		tab_group_note.add(new FlxText(stepperSusLength.x, stepperSusLength.y - 16, 0, 'Note Sustain Length', 8));
		tab_group_note.add(stepperSusLength);
		tab_group_note.add(new FlxText(UI_note.x, UI_note.y - 16, 0, 'Note Event:', 8));
		tab_group_note.add(UI_note);

		Main_UI.addGroup(tab_group_note);
	}

	function loadSong(daSong:String):Void
	{
		if (FlxG.sound.music != null) FlxG.sound.music.stop();

		FlxG.sound.playMusic(AssetPaths.song_inst(daSong.toLowerCase()), 0.6, false);
		if (_song.needsVoices) vocals = new FlxSound().loadEmbedded(AssetPaths.song_voices(daSong.toLowerCase()));
		else
			vocals = new FlxSound();
		FlxG.sound.list.add(vocals);

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.onComplete = function() {
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}

	function generateUI():Void
	{
		while (bullshitUI.members.length > 0)
			bullshitUI.remove(bullshitUI.members[0], true);

		// general shit
		var title:FlxText = new FlxText(Main_UI.x + 20, Main_UI.y + 20, 0);
		bullshitUI.add(title);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if (id == FlxUICheckBox.CLICK_EVENT)
		{
			var check:FlxUICheckBox = cast sender;
			var label = check.getLabel().text;
			switch (label)
			{
				case 'Must hit section':
					_song.notes[curSection].mustHitSection = check.checked;

					updateHeads();

				case 'Change BPM':
					_song.notes[curSection].changeBPM = check.checked;
					FlxG.log.add('changed bpm shit');
				case "Alt Animation":
					_song.notes[curSection].altAnim = check.checked;
			}
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			FlxG.log.add(wname);
			if (wname == 'section_length')
			{
				modifMade('Section Length');
				_song.notes[curSection].lengthInSteps = Std.int(nums.value);
				updateGrid();
			}
			else if (wname == 'song_speed')
			{
				if (nums.value != _song.speed) modifMade('Song Speed');

				_song.speed = nums.value;
			}
			else if (wname == 'song_bpm')
			{
				tempBpm = Std.int(nums.value);
				Conductor.mapBPMChanges(_song);
				Conductor.changeBPM(Std.int(nums.value));
			}
			else if (wname == 'note_susLength')
			{
				if (curSelectedNote == null) return;
				if (curSelectedNote.length < 3) return;
				if (curSelectedNote[2] == null) return;

				curSelectedNote[2] = nums.value;
				modifMade('Note sus length');
				updateGrid();
			}
			else if (wname == 'section_bpm')
			{
				_song.notes[curSection].bpm = Std.int(nums.value);
				updateGrid();
			}
		}
	}

	var updatedSection:Bool = false;

	function sectionStartTime():Float
	{
		var daBPM:Float = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection)
		{
			if (_song.notes[i].changeBPM) daBPM = _song.notes[i].bpm;
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	override function update(elapsed:Float)
	{
		curStep = recalculateSteps();

		if (FlxG.sound.music.time < 0) FlxG.sound.music.time = 0;

		Conductor.songPosition = FlxG.sound.music.time;

		makeBPMText();

		if (UI_songTitle.hasFocus) typingShit = UI_songTitle;
		if (UI_songAuthors.hasFocus) typingShit = UI_songAuthors;
		if (UI_note.hasFocus) typingShit = UI_note;
		if (eventValue.hasFocus) typingShit = eventValue;
		if (eventDropDown.hasFocus) typingShit = eventDropDown;

		_song.song = UI_songTitle.text;
		_song.authors = UI_songAuthors.text;

		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps));

		if (curBeat % 4 == 0 && curStep >= 16 * (curSection + 1))
		{
			trace(curStep);
			trace((_song.notes[curSection].lengthInSteps) * (curSection + 1));
			trace('DUMBSHIT');

			if (_song.notes[curSection + 1] == null) addSection();

			changeSection(curSection + 1, false);
		}

		FlxG.watch.addQuick('daBeat', curBeat);
		FlxG.watch.addQuick('daStep', curStep);

		if (FlxG.mouse.justPressed)
		{
			if (FlxG.mouse.overlaps(curRenderedNotes))
			{
				curRenderedNotes.forEach(function(note:Note) {
					if (FlxG.mouse.overlaps(note))
					{
						if (FlxG.keys.pressed.CONTROL) selectNote(note);
						else
						{
							trace('tryin to delete note...');
							deleteNote(note);
						}
					}
				});
			}
			else
			{
				if (FlxG.mouse.x > gridBG.x
					&& FlxG.mouse.x < gridBG.x + gridBG.width
					&& FlxG.mouse.y > gridBG.y
					&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
				{
					FlxG.log.add('added note');
					addNote();
				}
			}
		}

		if (FlxG.mouse.x > gridBG.x
			&& FlxG.mouse.x < gridBG.x + gridBG.width
			&& FlxG.mouse.y > gridBG.y
			&& FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps))
		{
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
			if (FlxG.keys.pressed.SHIFT) dummyArrow.y = FlxG.mouse.y;
			else
				dummyArrow.y = Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE;
		}

		if (!typingShit.hasFocus)
		{
			var shiftThing:Int = 1;
			if (FlxG.keys.pressed.SHIFT) shiftThing = 4;
			if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) changeSection(curSection + shiftThing);
			if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) changeSection(curSection - shiftThing);

			if (FlxG.keys.justPressed.ENTER)
			{
				lastSection = curSection;

				FlxG.sound.music.stop();
				vocals.stop();

				PlayState.SONG = _song;
				PlayState.IS_CHARTINGMODE = true;
				FlxG.switchState(() -> new PlayState());
			}

			if (FlxG.keys.justPressed.P) addEvent();

			if (FlxG.keys.justPressed.E)
			{
				modifMade('Note sus length (keybind)');
				changeNoteSustain(Conductor.stepCrochet);
			}
			if (FlxG.keys.justPressed.Q)
			{
				modifMade('Note sus length (keybind)');
				changeNoteSustain(-Conductor.stepCrochet);
			}

			if (FlxG.keys.justPressed.TAB) if (FlxG.keys.pressed.SHIFT)
			{
				Main_UI.selected_tab -= 1;
				if (Main_UI.selected_tab < 0) Main_UI.selected_tab = Main_UI.numTabs - 1;
			}
			else
			{
				Main_UI.selected_tab += 1;
				if (Main_UI.selected_tab >= Main_UI.numTabs - 1) Main_UI.selected_tab = 0;
			}

			if (FlxG.keys.justPressed.SPACE) if (FlxG.sound.music.playing)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}
			else
			{
				vocals.play();
				FlxG.sound.music.play();
			}

			if (FlxG.keys.justPressed.R) if (FlxG.keys.pressed.SHIFT) resetSection(true);
			else
				resetSection();

			var daTime:Float = (!FlxG.keys.pressed.SHIFT) ? 700 * FlxG.elapsed : Conductor.stepCrochet * 2;
			if (FlxG.keys.pressed.W || FlxG.keys.pressed.S)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				if (FlxG.keys.pressed.W) FlxG.sound.music.time -= daTime;
				else
					FlxG.sound.music.time += daTime;

				vocals.time = FlxG.sound.music.time;
			}
		}
		else
		{
			if (FlxG.keys.justReleased.ANY)
			{
				modifMade('Typing(${typingShit.text})');

				if (UI_note.hasFocus) updateGrid();
			}
		}

		if (curSelectedNote != null && UI_note.hasFocus) curSelectedNote[3] = UI_note.text;

		_song.bpm = tempBpm;

		super.update(elapsed);
	}

	function changeNoteSustain(value:Float):Void
	{
		if (curSelectedNote != null) if (curSelectedNote[2] != null)
		{
			curSelectedNote[2] += value;
			curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
		}

		updateNoteUI();
		updateGrid();
	}

	function recalculateSteps():Int
	{
		var lastChange:BPMChangeEvent =
			{
				stepTime: 0,
				songTime: 0,
				bpm: 0
			}
		for (i in 0...Conductor.bpmChangeMap.length)
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime) lastChange = Conductor.bpmChangeMap[i];

		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();

		return curStep;
	}

	function resetSection(songBeginning:Bool = false):Void
	{
		updateGrid();

		FlxG.sound.music.pause();
		vocals.pause();

		// Basically old shit from changeSection???
		FlxG.sound.music.time = sectionStartTime();

		if (songBeginning)
		{
			FlxG.sound.music.time = 0;
			curSection = 0;
		}

		vocals.time = FlxG.sound.music.time;
		updateCurStep();

		updateGrid();
		updateSectionUI();
	}

	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void
	{
		trace('changing section' + sec);

		if (_song.notes[sec] != null)
		{
			curSection = sec;

			updateGrid();

			if (updateMusic)
			{
				FlxG.sound.music.pause();
				vocals.pause();

				FlxG.sound.music.time = sectionStartTime();
				vocals.time = FlxG.sound.music.time;
				updateCurStep();
			}

			updateGrid();
			updateSectionUI();
		}
	}

	function copySection(?sectionNum:Int = 1)
	{
		var daSec = FlxMath.maxInt(curSection, sectionNum);

		for (note in _song.notes[daSec - sectionNum].sectionNotes)
		{
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);

			var copiedNote:Array<Dynamic> = [strum, note[1], note[2], note[3]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}

		updateGrid();
	}

	function updateSectionUI():Void
	{
		var sec = _song.notes[curSection];

		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;

		updateHeads();
	}

	function updateHeads():Void
	{
		if (check_mustHitSection?.checked ?? true)
		{
			leftIcon.char = 'bf';
			rightIcon.char = 'dad';
		}
		else
		{
			leftIcon.char = 'dad';
			rightIcon.char = 'bf';
		}
	}

	function updateNoteUI():Void
	{
		if (curSelectedNote != null) stepperSusLength.value = curSelectedNote[2];
		if (curSelectedNote != null && curSelectedNote[3] != null) UI_note.text = curSelectedNote[3];
	}

	function updateGrid():Void
	{
		while (curRenderedEvents.members.length > 0)
			curRenderedEvents.remove(curRenderedEvents.members[0], true);

		while (curRenderedEventTexts.members.length > 0)
			curRenderedEventTexts.remove(curRenderedEventTexts.members[0], true);

		while (curRenderedNotes.members.length > 0)
			curRenderedNotes.remove(curRenderedNotes.members[0], true);

		while (curRenderedSustains.members.length > 0)
			curRenderedSustains.remove(curRenderedSustains.members[0], true);

		var notes:Array<Dynamic> = _song.notes[curSection].sectionNotes;
		var events:Array<Dynamic> = _song.notes[curSection].sectionEvents;

		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0)
		{
			Conductor.changeBPM(_song.notes[curSection].bpm);
			FlxG.log.add('CHANGED BPM!');
		}
		else
		{
			// get last bpm
			var daBPM:Float = _song.bpm;
			for (i in 0...curSection)
				if (_song.notes[i].changeBPM) daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}

		for (i in notes)
		{
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];
			var event = i[3];

			var note:Note = new Note(daStrumTime, daNoteInfo % 4, false, event);
			note.sustainLength = daSus;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.updateHitbox();
			note.x = Math.floor(daNoteInfo * GRID_SIZE);
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));

			curRenderedNotes.add(note);

			if (daSus > 0)
			{
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2),
					note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * 16, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}
		}

		for (i in events)
		{
			var daStrumTime = i[0];
			var eventName = i[1];
			var eventValue = i[2];

			var defaultPath:String = AssetPaths.image('events/default', 'ui');
			var curEventPath:String = AssetPaths.image('events/$eventName', 'ui');
			var curEventValuePath:String = AssetPaths.image('events/$eventName=$eventValue', 'ui');

			var event:FunkinSprite = new FunkinSprite();
			var loadedImg:Bool = true;

			if (KoyaAssets.exists(curEventValuePath)) event.loadGraphic(curEventValuePath);
			else if (KoyaAssets.exists(curEventPath)) event.loadGraphic(curEventPath);
			else if (KoyaAssets.exists(defaultPath)) event.loadGraphic(defaultPath);
			else
			{
				loadedImg = false;
				event.makeGraphic(Math.round(GRID_SIZE / 2), Math.round(GRID_SIZE / 2));
			}
			if (loadedImg)
			{
				event.setGraphicSize(Math.round(GRID_SIZE));
				event.updateHitbox();
			}

			event.x = gridBG.x - event.width;
			event.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));

			var eventText:FlxText = new FlxText(event.getGraphicMidpoint().x, event.getGraphicMidpoint().y, 0, '$eventName : $eventValue', 8);
			eventText.alignment = RIGHT;
			eventText.x -= eventText.width;
			curRenderedEventTexts.add(eventText);

			curRenderedEvents.add(event);
		}
		curRenderedEvents.sort(FlxSort.byY, FlxSort.DESCENDING);
		curRenderedEventTexts.sort(FlxSort.byY, FlxSort.DESCENDING);

		updateHeads();
	}

	private function addSection(lengthInSteps:Int = 16):Void
	{
		var sec:SwagSection =
			{
				lengthInSteps: lengthInSteps,
				bpm: _song.bpm,
				changeBPM: false,
				mustHitSection: true,
				sectionNotes: [],
				sectionEvents: [],
				altAnim: false
			};

		_song.notes.push(sec);
	}

	function selectNote(note:Note):Void
	{
		var swagNum:Int = 0;

		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i.strumTime == note.strumTime && i.noteID % 4 == note.noteID) curSelectedNote = _song.notes[curSection].sectionNotes[swagNum];

			swagNum += 1;
		}

		updateGrid();
		updateNoteUI();
	}

	function deleteNote(note:Note):Void
	{
		modifMade('Delete Note');

		for (i in _song.notes[curSection].sectionNotes)
		{
			if (i[0] == note.strumTime && i[1] % 4 == note.noteID)
			{
				FlxG.log.add('FOUND EVIL NUMBER');
				_song.notes[curSection].sectionNotes.remove(i);
			}
		}

		updateGrid();
	}

	function clearSection():Void
	{
		_song.notes[curSection].sectionNotes = [];
		modifMade('Clear Section');

		updateGrid();
	}

	function clearSong():Void
	{
		for (daSection in 0..._song.notes.length)
			_song.notes[daSection].sectionNotes = [];

		updateGrid();
	}

	private function addNote():Void
	{
		modifMade('Add Note');

		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteID = Math.floor(FlxG.mouse.x / GRID_SIZE);
		var noteSus = 0;
		var noteEventShit = UI_note.text;

		var note:Array<Dynamic> = [noteStrum, noteID, noteSus, noteEventShit];

		_song.notes[curSection].sectionNotes.push(note);
		modifMade('Added note($note)');

		curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];

		if (FlxG.keys.pressed.CONTROL) _song.notes[curSection].sectionNotes.push([note[0], (noteID + 4) % 8, note[2], note[3]]);

		trace(noteStrum);
		trace(noteEventShit);
		trace(curSection);

		updateGrid();
		updateNoteUI();

		if (Save.preferences.get().chartEditorAutosave) autosaveSong();
	}

	function getStrumTime(yPos:Float):Float
	{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}

	function getYfromStrum(strumTime:Float):Float
	{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}

	private var daSpacing:Float = 0.3;

	function loadLevel():Void
	{
		trace(_song.notes);
	}

	function getNotes():Array<Dynamic>
	{
		var noteID:Array<Dynamic> = [];

		for (i in _song.notes)
			noteID.push(i.sectionNotes);

		return noteID;
	}

	function loadJson(song:String, chart:String):Void
	{
		trace(AssetPaths.chart(song.toLowerCase(), chart));
		PlayState.SONG = Song.loadFromJson(chart ?? song.toLowerCase(), song.toLowerCase(), false);
		FlxG.resetState();
	}

	function loadAutosave():Void
	{
		PlayState.SONG = Song.parseJSONshit(Save.autosave.get());

		FlxG.resetState();
	}

	function autosaveSong():Void
	{
		Save.autosave.set(
			{
				song: _song
			});
		Save.flush();
	}

	public function modifMade(?modif:String)
	{
		trace('chart modif : ${modif ?? 'Unknown'}');
		_song.generatedBy = '${Constants.SONG_GENERATED_BY_PREFIX}Chart Editor (${Constants.SONG_FORMAT})';
	}

	private function saveLevel()
	{
		var json:ChartSwagSong =
			{
				song: _song
			};

		var data:String = Json.stringify(json, '\t');

		if ((data != null) && (data.length > 0))
		{
			var path = AssetPaths.chart(curSong.toLowerCase(), '${curSong.toLowerCase()}${_song.difficulty.chartSuffix()}');
			trace(path);

			#if INSTA_SAVE
			try
			{
				sys.io.File.saveContent(path, data);
				return;
			}
			catch (e)
			{
				trace(e);
			}
			#end

			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, path);
		}
	}

	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved LEVEL DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the gameplay recording.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Level data");
	}
}
