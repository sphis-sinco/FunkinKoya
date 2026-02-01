package koya.backend.save;

import koya.backend.controls.Controls;
import lime.app.Application;
import koya.backend.controls.PlayerSettings;
import flixel.FlxG;
import koya.backend.songs.Song.ChartSwagSong;

class Save
{
	public static var SAVE_VERSION:Null<Int> = 2;

	public static var version:SaveField<Null<Int>> = new SaveField('version', SAVE_VERSION);

	public static var songScores:SaveField<Map<String, Int>> = new SaveField('songScores');
	public static var autosave:SaveField<ChartSwagSong> = new SaveField('autosave');
	public static var controls:SaveField<Dynamic> = new SaveField('controls');

	public static var keybind_reset:SaveField<String> = new SaveField('keybind_reset', 'R');

	public static var keybind_ui_left_alt:SaveField<String> = new SaveField('keybind_ui_left_alt', 'A');
	public static var keybind_ui_down_alt:SaveField<String> = new SaveField('keybind_ui_down_alt', 'S');
	public static var keybind_ui_up_alt:SaveField<String> = new SaveField('keybind_ui_up_alt', 'W');
	public static var keybind_ui_right_alt:SaveField<String> = new SaveField('keybind_ui_right_alt', 'D');

	public static var keybind_ui_left:SaveField<String> = new SaveField('keybind_ui_left', 'LEFT');
	public static var keybind_ui_down:SaveField<String> = new SaveField('keybind_ui_down', 'DOWN');
	public static var keybind_ui_up:SaveField<String> = new SaveField('keybind_ui_up', 'UP');
	public static var keybind_ui_right:SaveField<String> = new SaveField('keybind_ui_right', 'RIGHT');

	public static function init()
	{
		PlayerSettings.init();
		FlxG.save.bind('koya', 'Macohi');
		Highscore.load();

		if (version.get() == SAVE_VERSION) return;

		upgradeVersion();

		flush();

		Application.current.onExit.add(function(l) {
			flush();
		});
	}

	public static function upgradeVersion()
	{
		switch (version.get())
		{
			default:
				trace('unimplemented upgrade from version: ${version.get()}');
		}

		if (version.get() < SAVE_VERSION)
			upgradeVersion();
	}

	public static function flush()
	{
		version.set(SAVE_VERSION);
		FlxG.save.flush();
	}
}
