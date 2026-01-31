package koya.backend.tasks;

import koya.backend.play.Difficulty;
import haxe.Json;

class ResaveAllSongs
{
	public static function run()
	{
		#if sys
		var freeplaySonglist = CoolUtil.coolTextFile(AssetPaths.txt('data/freeplaySonglist', 'songs'));
		var songList = [];
		for (song in freeplaySonglist)
		{
			for (difficulty in Difficulty.list)
			{
				trace('song: $song | difficulty: $difficulty');
				var myJSON = Song.loadFromJson(Highscore.formatSong(song.toLowerCase(), difficulty), song);

				if (myJSON != null)
				{
					songList.push(myJSON);
					var curSong = myJSON.song.toLowerCase();
					var path = '../../../../' + AssetPaths.chart(curSong, '$curSong${difficulty.chartSuffix()}');

					myJSON.authors = 'Kawai Sprite';
					switch (curSong)
					{
						case 'south', 'spookeez':
							myJSON.player2 = 'dad';

						case 'monster':
							myJSON.authors = 'Bassetfilms';
							myJSON.player2 = 'dad';
					}

					myJSON.generatedBy = '${Constants.SONG_GENERATED_BY_PREFIX}Task: Resave All Songs';

					trace('saving $path');
					sys.io.File.saveContent(path, Json.stringify({song: myJSON}, '\t'));
				}
			}
		}
		if (songList.length < 0) trace('Task Uncompleted : No Songs');
		else
			trace('Task Completed : Reexported ${songList.length} songs');
		Sys.exit(0);
		#else
		trace('Task Uncompleted : Not Sys');
		throw 'Not Sys';
		#end
	}
}
