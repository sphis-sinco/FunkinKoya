package koya.backend.save;

import koya.backend.play.Rank;
import koya.backend.controls.Controls;
import lime.app.Application;
import koya.backend.controls.PlayerSettings;
import flixel.FlxG;
import koya.backend.songs.Song.ChartSwagSong;

class Save
{
	public static var SAVE_VERSION:Null<Int> = 4;

	public static var version:SaveField<Null<Int>>;

	public static var songScores:SaveField<Map<String, Int>>;
	public static var songRanks:SaveField<Map<String, Rank>>;

	public static var autosave:SaveField<ChartSwagSong>;
	public static var controls:SaveField<Dynamic>;

	public static var keybind_reset:SaveField<String>;

	public static var keybind_ui_left_alt:SaveField<String>;
	public static var keybind_ui_down_alt:SaveField<String>;
	public static var keybind_ui_up_alt:SaveField<String>;
	public static var keybind_ui_right_alt:SaveField<String>;

	public static var keybind_ui_left:SaveField<String>;
	public static var keybind_ui_down:SaveField<String>;
	public static var keybind_ui_up:SaveField<String>;
	public static var keybind_ui_right:SaveField<String>;

	public static var keybind_note_left_alt:SaveField<String>;
	public static var keybind_note_down_alt:SaveField<String>;
	public static var keybind_note_up_alt:SaveField<String>;
	public static var keybind_note_right_alt:SaveField<String>;

	public static var keybind_note_left:SaveField<String>;
	public static var keybind_note_down:SaveField<String>;
	public static var keybind_note_up:SaveField<String>;
	public static var keybind_note_right:SaveField<String>;

	public static var preferences:SaveField<Preferences>;

	public static var enabledMods:SaveField<Array<String>>;

	public static var keybinds:Array<SaveField<String>> = [];

	static function initFields()
	{
		version = new SaveField<Null<Int>>('version', SAVE_VERSION);

		songScores = new SaveField<Map<String, Int>>('songScores');
		songRanks = new SaveField<Map<String, Rank>>('songRanks');

		autosave = new SaveField<ChartSwagSong>('autosave');
		controls = new SaveField<Dynamic>('controls');

		keybind_reset = new SaveField<String>('keybind_reset', 'R');

		keybind_ui_left_alt = new SaveField<String>('keybind_ui_left_alt', 'A');
		keybind_ui_down_alt = new SaveField<String>('keybind_ui_down_alt', 'S');
		keybind_ui_up_alt = new SaveField<String>('keybind_ui_up_alt', 'W');
		keybind_ui_right_alt = new SaveField<String>('keybind_ui_right_alt', 'D');

		keybind_ui_left = new SaveField<String>('keybind_ui_left', 'LEFT');
		keybind_ui_down = new SaveField<String>('keybind_ui_down', 'DOWN');
		keybind_ui_up = new SaveField<String>('keybind_ui_up', 'UP');
		keybind_ui_right = new SaveField<String>('keybind_ui_right', 'RIGHT');

		keybind_note_left_alt = new SaveField<String>('keybind_note_left_alt', 'A');
		keybind_note_down_alt = new SaveField<String>('keybind_note_down_alt', 'S');
		keybind_note_up_alt = new SaveField<String>('keybind_note_up_alt', 'W');
		keybind_note_right_alt = new SaveField<String>('keybind_note_right_alt', 'D');

		keybind_note_left = new SaveField<String>('keybind_note_left', 'LEFT');
		keybind_note_down = new SaveField<String>('keybind_note_down', 'DOWN');
		keybind_note_up = new SaveField<String>('keybind_note_up', 'UP');
		keybind_note_right = new SaveField<String>('keybind_note_right', 'RIGHT');

		keybinds = [
			keybind_reset,
			null,

			keybind_ui_left,
			keybind_ui_down,
			keybind_ui_up,
			keybind_ui_right,
			null,

			keybind_ui_left_alt,
			keybind_ui_down_alt,
			keybind_ui_up_alt,
			keybind_ui_right_alt,
			null,

			keybind_note_left,
			keybind_note_down,
			keybind_note_up,
			keybind_note_right,
			null,
			
			keybind_note_up_alt,
			keybind_note_left_alt,
			keybind_note_down_alt,
			keybind_note_right_alt,
			null,
		];

		preferences = new SaveField<Preferences>('preferences',
			{
				fpsCounter: true,
				chartEditorAutosave: true,
			});

		enabledMods = new SaveField<Array<String>>('enabledMods', []);
	}

	public static function init()
	{
		FlxG.save.bind('koya', 'Macohi');

		initFields();

		PlayerSettings.init();
		Highscore.load();

		upgradeVersion(() -> {
			flush();
			for (field in Reflect.fields(FlxG.save.data))
			{
				if (!Reflect.fields(Save).contains(field)) continue;
				if (field == 'autosave') continue;

				trace('Save.${field} : ${Reflect.field(FlxG.save.data, field)}');
			}
		});

		Application.current.onExit.add(function(l) {
			flush();
		});
	}

	public static function upgradeVersion(?onComplete:Void->Void)
	{
		switch (version.get())
		{
			default:
				trace('unimplemented upgrade from version: ${version.get()}');
		}

		version.set(version.get() + 1);
		if (version.get() < SAVE_VERSION)
		{
			upgradeVersion(onComplete);
		}
		else
		{
			if (onComplete != null) onComplete();
		}
	}

	public static function flush()
	{
		version.set(SAVE_VERSION);
		FlxG.save.flush();
	}
}
