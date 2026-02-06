package koya.backend.songs;

import koya.backend.play.Difficulty;
import koya.backend.KoyaAssets;
import koya.backend.songs.Song.SwagSong;
import haxe.Json;

class SongList
{
	public static var weekList:WeekList = new WeekList();

	public static var songList(get, never):Array<SwagSong>;

	static function get_songList():Array<SwagSong>
	{
		var list:Array<SwagSong> = [];

		for (entry in weekList.textList)
		{
			var weekJSON:Week;

			try
			{
				weekJSON = Json.parse(KoyaAssets.getText(weekList.getEntryFilePath(entry)));
			}
			catch (e)
			{
				trace(e.message);
				weekJSON = null;
			}

			if (weekJSON == null) continue;

			for (song in weekJSON.songs)
			{
				var songJSON:SwagSong = null;

				for (diff in Difficulty.list)
				{
					songJSON = Song.loadFromJson(song.toLowerCase(), Highscore.formatToDifficulty(song.toLowerCase(), diff), false);
					if (songJSON != null) continue;
				}

				if (songJSON != null) list.push(songJSON);
			}
		}

		return list;
	}

	public static var stringSongList(get, never):Array<String>;

	static function get_stringSongList():Array<String>
	{
		var list:Array<String> = [];

		for (song in songList)
			list.push(song.song);

		trace(list);
		return list;
	}
}
