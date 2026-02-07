package koya.backend.save;

import koya.backend.play.Rank;
import koya.backend.controls.Controls;
import lime.app.Application;
import koya.backend.controls.PlayerSettings;
import flixel.FlxG;
import koya.backend.songs.Song.ChartSwagSong;

class Save
{
	/** Save Version **/
	public static var SAVE_VERSION:Null<Int> = 6;

	/** Save Field: version : this is the last save version you had and will be used to check if you need to upgrade **/
	public static var version:SaveField<Null<Int>>;

	/** Save Field: songScores : Map of your song scores (Check out `koya.backend.Highscore` for more info) **/
	public static var songScores:SaveField<Map<String, Int>>;
	/** Save Field: songScores : Map of your song ranks (Check out `koya.backend.Highscore` for more info) **/
	public static var songRanks:SaveField<Map<String, Rank>>;

	/** Save Field: autosave : chart editor autosave **/
	public static var autosave:SaveField<ChartSwagSong>;

	/** Save Field: keybind_reset : Keybind for RESET **/
	public static var keybind_reset:SaveField<String>;

	/** Save Field: keybind_reset : Keybind for UI Left **/
	public static var keybind_ui_left:SaveField<String>;
	/** Save Field: keybind_reset : Keybind for UI Down **/
	public static var keybind_ui_down:SaveField<String>;
	/** Save Field: keybind_reset : Keybind for UI Up **/
	public static var keybind_ui_up:SaveField<String>;
	/** Save Field: keybind_reset : Keybind for UI Right **/
	public static var keybind_ui_right:SaveField<String>;

	/** Save Field: keybind_reset : Alt Keybind for UI Left **/
	public static var keybind_ui_left_alt:SaveField<String>;
	/** Save Field: keybind_reset : Alt Keybind for UI Down **/
	public static var keybind_ui_down_alt:SaveField<String>;
	/** Save Field: keybind_reset : Alt Keybind for UI Up **/
	public static var keybind_ui_up_alt:SaveField<String>;
	/** Save Field: keybind_reset : Alt Keybind for UI Right **/
	public static var keybind_ui_right_alt:SaveField<String>;

	/** Save Field: keybind_reset : Keybind for Note Left **/
	public static var keybind_note_left:SaveField<String>;
	/** Save Field: keybind_reset : Keybind for Note Down **/
	public static var keybind_note_down:SaveField<String>;
	/** Save Field: keybind_reset : Keybind for Note Up **/
	public static var keybind_note_up:SaveField<String>;
	/** Save Field: keybind_reset : Keybind for Note Right **/
	public static var keybind_note_right:SaveField<String>;

	/** Save Field: keybind_reset : Alt Keybind for Note Left **/
	public static var keybind_note_left_alt:SaveField<String>;
	/** Save Field: keybind_reset : Alt Keybind for Note Down **/
	public static var keybind_note_down_alt:SaveField<String>;
	/** Save Field: keybind_reset : Alt Keybind for Note Up **/
	public static var keybind_note_up_alt:SaveField<String>;
	/** Save Field: keybind_reset : Alt Keybind for Note Right **/
	public static var keybind_note_right_alt:SaveField<String>;

	/** Save Field: preferences : Options data **/
	public static var preferences:SaveField<Preferences>;

	/** Save Field: enabledMods : Array of enabled mods **/
	public static var enabledMods:SaveField<Array<String>>;

	/** List of keybinds to make making their lists easier **/
	public static var keybinds:Array<SaveField<String>> = [];

	/** Initalize all save fields and variables associating with them **/
	static function initFields()
	{
		version = new SaveField<Null<Int>>('version', SAVE_VERSION);

		songScores = new SaveField<Map<String, Int>>('songScores');
		songRanks = new SaveField<Map<String, Rank>>('songRanks');

		autosave = new SaveField<ChartSwagSong>('autosave');

		keybind_reset = new SaveField<String>('keybind_reset', 'R', 'Keybind: RESET');

		keybind_ui_left_alt = new SaveField<String>('keybind_ui_left_alt', 'A', 'Keybind: UI_LEFT_ALT');
		keybind_ui_down_alt = new SaveField<String>('keybind_ui_down_alt', 'S', 'Keybind: UI_DOWN_ALT');
		keybind_ui_up_alt = new SaveField<String>('keybind_ui_up_alt', 'W', 'Keybind: UI_UP_ALT');
		keybind_ui_right_alt = new SaveField<String>('keybind_ui_right_alt', 'D', 'Keybind: UI_RIGHT_ALT');

		keybind_ui_left = new SaveField<String>('keybind_ui_left', 'LEFT', 'Keybind: UI_LEFT');
		keybind_ui_down = new SaveField<String>('keybind_ui_down', 'DOWN', 'Keybind: UI_DOWN');
		keybind_ui_up = new SaveField<String>('keybind_ui_up', 'UP', 'Keybind: UI_UP');
		keybind_ui_right = new SaveField<String>('keybind_ui_right', 'RIGHT', 'Keybind: UI_RIGHT');

		keybind_note_left_alt = new SaveField<String>('keybind_note_left_alt', 'A', 'Keybind: NOTE_LEFT_ALT');
		keybind_note_down_alt = new SaveField<String>('keybind_note_down_alt', 'S', 'Keybind: NOTE_DOWN_ALT');
		keybind_note_up_alt = new SaveField<String>('keybind_note_up_alt', 'W', 'Keybind: NOTE_UP_ALT');
		keybind_note_right_alt = new SaveField<String>('keybind_note_right_alt', 'D', 'Keybind: NOTE_RIGHT_ALT');

		keybind_note_left = new SaveField<String>('keybind_note_left', 'LEFT', 'Keybind: NOTE_LEFT');
		keybind_note_down = new SaveField<String>('keybind_note_down', 'DOWN', 'Keybind: NOTE_DOWN');
		keybind_note_up = new SaveField<String>('keybind_note_up', 'UP', 'Keybind: NOTE_UP');
		keybind_note_right = new SaveField<String>('keybind_note_right', 'RIGHT', 'Keybind: NOTE_RIGHT');

		keybinds = [
			keybind_reset,
			null,

			keybind_ui_left,
			keybind_ui_down,
			keybind_ui_up,
			keybind_ui_right,

			keybind_ui_left_alt,
			keybind_ui_down_alt,
			keybind_ui_up_alt,
			keybind_ui_right_alt,
			null,

			keybind_note_left,
			keybind_note_down,
			keybind_note_up,
			keybind_note_right,

			keybind_note_left_alt,
			keybind_note_down_alt,
			keybind_note_up_alt,
			keybind_note_right_alt,
			null,
		];

		preferences = new SaveField<Preferences>('preferences',
			{
				fpsCounter: true,
				chartEditorAutosave: true,

				ghostTapping: true,
				downScroll: false,

				flashingLights: true,
			});

		enabledMods = new SaveField<Array<String>>('enabledMods', []);
	}

	/** Initalize save data, attempt upgrading, and then load save data for classes that have functions for it **/
	public static function init()
	{
		FlxG.save.bind('koya', 'Macohi');

		initFields();

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

		// Technically unrequired now but just in case
		PlayerSettings.init();
		Highscore.load();
	}

	/**
		Attempt upgrading to the latest save version

		@param onComplete function for when upgrading is complete
	**/
	public static function upgradeVersion(?onComplete:Void->Void)
	{
		switch (version.get())
		{
			case 4:
				preferences.get().downScroll ??= false;
				preferences.get().ghostTapping ??= true;

				preferences.get().flashingLights ??= true;
			
			case 5:
				Reflect.deleteField(FlxG.save.data, 'controls');

			default:
				trace('unimplemented upgrade from version: ${version.get()}');
		}

		preferences.get().downScroll = false;

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

	/** Set the version and run `FlxG.save.flush()` **/
	public static function flush()
	{
		version.set(SAVE_VERSION);
		FlxG.save.flush();
	}
}
