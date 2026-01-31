package frontend.play.songs;

import frontend.play.songs.week1.TutorialScript;

class SongClassGetter
{
	public static function getSongClass(song:String):SongClass
	{
		switch (song.toLowerCase())
		{
			case 'tutorial':
				return new TutorialScript();
		}

		return new SongClass();
	}
}
