package koya.backend.save;

import lime.app.Application;
import koya.backend.controls.PlayerSettings;
import flixel.FlxG;
import koya.backend.songs.Song.ChartSwagSong;

class Save
{
	public static var SAVE_VERSION:Int = 1;

	public static var version:SaveField<Int> = new SaveField('version', SAVE_VERSION);

	public static var songScores:SaveField<Map<String, Int>> = new SaveField('songScores');
	public static var autosave:SaveField<ChartSwagSong> = new SaveField('autosave');
	public static var controls:SaveField<Dynamic> = new SaveField('controls');

	public static function init()
	{
		PlayerSettings.init();
		FlxG.save.bind('koya', 'Macohi');
		Highscore.load();

		if (version.get() == SAVE_VERSION) return;

		switch (version.get())
		{
			default:
				trace('unimplemented switch to version: ${version.get()}');
		}

		flush();

		Application.current.onExit.add(function(l) {
			flush();
		});
	}

	public static function flush()
	{
		version.set(SAVE_VERSION);
		FlxG.save.flush();
	}
}
