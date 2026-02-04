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
				var myJSON = Song.loadFromJson(Highscore.formatToDifficulty(song.song.toLowerCase(), difficulty), song.song.toLowerCase());
				var myJSONnofix = Song.loadFromJson(Highscore.formatToDifficulty(song.song.toLowerCase(), difficulty), song.song.toLowerCase(), false);

				// if (myJSON == null) continue;
				// if (myJSONnofix == null || myJSONnofix.version != null) continue;

				myJSON.difficulty = difficulty;

				// songList.push(myJSON);
				var curSong = myJSON.song.toLowerCase();
				var path = '../../../../' + AssetPaths.chart(curSong, '$curSong${difficulty.chartSuffix()}');

				myJSON.authors = 'Kawai Sprite';
				switch (curSong)
				{
					case 'winter-horrorland':
						myJSON.authors = 'Bassetfilms';

						myJSON.player1 = 'bf';
						myJSON.player2 = 'monster';
						myJSON.gfVersion = 'gf';
						myJSON.stage = 'christmasEvil';

					case 'cocoa', 'eggnog':
						myJSON.player1 = 'bf';
						myJSON.player2 = 'dad';
						myJSON.gfVersion = 'gf';

						myJSON.stage = 'christmas';

					case 'milf', 'satin-panties', 'high':
						myJSON.player1 = 'bf';
						myJSON.player2 = 'mom';
						myJSON.gfVersion = 'gf';

						myJSON.stage = 'limo';

					case 'blammed', 'pico', 'philly':
						myJSON.player1 = 'bf';
						myJSON.player2 = 'pico';
						myJSON.gfVersion = 'gf';

						myJSON.stage = 'philly';
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
