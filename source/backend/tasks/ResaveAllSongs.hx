package backend.tasks;

import backend.play.Difficulty;
import haxe.Json;

class ResaveAllSongs
{
	public static function run()
	{
		#if sys
		var freeplaySonglist = CoolUtil.coolTextFile(AssetPaths.txt('data/freeplaySonglist'));
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

					switch (curSong)
					{
						case 'tutorial', 'bopeebo', 'fresh', 'dadbattle':
							myJSON.authors = 'Kawai Sprite';
					}

					myJSON.generatedBy = '${Constants.SONG_GENERATED_BY_PREFIX}Task: Resave All Songs';

					trace('saving $path');
					sys.io.File.saveContent(path, Json.stringify({song: myJSON}, '\t'));
				}
			}
		}
		trace('Task Completed : Reexported ${songList.length} songs');
		Sys.exit(0);
		#else
		trace('Task Uncompleted : Not Sys');
		throw 'Not Sys';
		#end
	}
}
