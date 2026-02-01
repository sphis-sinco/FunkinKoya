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
				// trace('song: ${song.song} | difficulty: $difficulty');
				var myJSON = Song.loadFromJson(Highscore.formatSong(song.song.toLowerCase(), difficulty), song.song.toLowerCase());
				myJSON.difficulty = difficulty;

				if (myJSON == null) continue;

				// songList.push(myJSON);
				var curSong = myJSON.song.toLowerCase();
				var path = '../../../../' + AssetPaths.chart(curSong, '$curSong${difficulty.chartSuffix()}');

				myJSON.authors = 'Kawai Sprite';
				switch (curSong)
				{
					case 'south', 'spookeez':
						myJSON.stage = 'halloween';
						myJSON.player1 = 'bf-spooky';
						myJSON.player2 = 'gf-spooky';
					case 'monster':
						myJSON.stage = 'halloween';
						myJSON.authors = 'Bassetfilms';
						myJSON.player1 = 'bf-spooky';
						myJSON.player2 = 'gf-spooky-monster';
				}

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
