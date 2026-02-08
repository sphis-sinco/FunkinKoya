package koya.backend.tasks;

import koya.backend.songs.SongList;
import koya.backend.songs.Song;
import koya.backend.play.Difficulty;
import haxe.Json;

using StringTools;

class ResaveAllSongs
{
	public static function run()
	{
		#if sys
		var songList = SongList.songList;
		var reexported = [];
		for (song in songList)
		{
			// trace(song);d
			// continue;

			for (difficulty in Difficulty.list)
			{
				var myJSON = Song.loadFromJson(Highscore.formatToDifficulty(song.song.toLowerCase(), difficulty), song.song.toLowerCase());

				myJSON.difficulty = difficulty;

				// songList.push(myJSON);
				var curSong = myJSON.song.toLowerCase();
				var path = '../../../../' + AssetPaths.chart(curSong, '$curSong${difficulty.chartSuffix()}');

				myJSON.generatedBy = '${Constants.SONG_GENERATED_BY_PREFIX}Task: Resave All Songs';

				// trace('saving $path');
				sys.io.File.saveContent(path, Json.stringify({song: myJSON}, '\t'));
				reexported.push(myJSON.song);
			}
		}
		if (reexported.length < 1) trace('Task Boringly Completed : No Songs reexported');
		else
			trace('Task Completed : Reexported ${reexported.length} song charts');
		Sys.exit(0);
		#else
		trace('Task Uncompleted : Not Sys');
		throw 'Not Sys';
		#end
	}
}
