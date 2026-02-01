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
		var fixedSongs = [];
		for (song in songList)
		{
			// trace(song);d
			// continue;

			for (difficulty in Difficulty.list)
			{
				// trace('song: ${song.song} | difficulty: $difficulty');
				var myJSONnoFix = Song.loadFromJson(Highscore.formatSong(song.song.toLowerCase(), difficulty), song.song.toLowerCase(), false);
				var myJSON = Song.loadFromJson(Highscore.formatSong(song.song.toLowerCase(), difficulty), song.song.toLowerCase());
				myJSON.difficulty = difficulty;

				if (myJSON == null) continue;
				if (myJSONnoFix == null) continue; // there should be no difference between them

				var fieldCheck:Int = Reflect.fields(myJSONnoFix).length;

				for (field in Reflect.fields(myJSONnoFix))
				{
					if (field == 'version') continue;

					var mjf:String = Std.string(Reflect.field(myJSON, field)).trim();
					var mjnff:String = Std.string(Reflect.field(myJSONnoFix, field)).trim();

					if (mjf != mjnff)
					{
						fieldCheck--;
						if (!['notes'].contains(field))
							trace('${song.song.toLowerCase()}${difficulty.chartSuffix()} : "$field : ${mjf}" != "$field : ${mjnff}"');
						else
							trace('${song.song.toLowerCase()}${difficulty.chartSuffix()} : "fixed : $field" != "notfixed : $field"');
					}
					else
					{
						// trace('${song.song.toLowerCase()}${difficulty.chartSuffix()} : "fixed : $field" == "notfixed : $field"');
					}
				}

				if (fieldCheck < Reflect.fields(myJSONnoFix).length) fixedSongs.push(myJSON.song);

				// songList.push(myJSON);
				var curSong = myJSON.song.toLowerCase();
				var path = '../../../../' + AssetPaths.chart(curSong, '$curSong${difficulty.chartSuffix()}');

				myJSON.authors = 'Kawai Sprite';
				switch (curSong)
				{
					case 'south', 'spookeez':
						myJSON.stage = 'halloween';
					case 'monster':
						myJSON.stage = 'halloween';
						myJSON.authors = 'Bassetfilms';
				}

				myJSON.generatedBy = '${Constants.SONG_GENERATED_BY_PREFIX}Task: Resave All Songs';

				// trace('saving $path');
				sys.io.File.saveContent(path, Json.stringify({song: myJSON}, '\t'));
			}
		}
		if (fixedSongs.length < 1) trace('Task Uncompleted : No Songs with (important) changes');
		else
			trace('Task Completed : Reexported ${fixedSongs.length} song charts with (important) changes');
		Sys.exit(0);
		#else
		trace('Task Uncompleted : Not Sys');
		throw 'Not Sys';
		#end
	}
}
