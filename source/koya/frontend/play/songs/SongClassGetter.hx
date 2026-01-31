package koya.frontend.play.songs;

import koya.frontend.play.songs.week1.FreshScript;
import koya.frontend.play.songs.week1.BopeeboScript;
import koya.frontend.play.songs.week1.TutorialScript;

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
