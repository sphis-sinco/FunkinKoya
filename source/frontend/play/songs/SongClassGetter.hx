package frontend.play.songs;

import frontend.play.songs.week1.FreshScript;
import frontend.play.songs.week1.BopeeboScript;
import frontend.play.songs.week1.TutorialScript;

class SongClassGetter
{
	public static function getSongClass(song:String):SongClass
	{
		switch (song.toLowerCase())
		{
			case 'tutorial':
				return new TutorialScript();
			case 'bopeebo':
				return new BopeeboScript();
			case 'fresh':
				return new FreshScript();
		}

		return new SongClass();
	}
}
