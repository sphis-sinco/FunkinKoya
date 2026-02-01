package koya.frontend.scenes.play.songs;

import koya.frontend.scenes.play.songs.week1.*;
import koya.frontend.scenes.play.songs.week2.*;

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
			case 'monster':
				return new MonsterScript();
		}

		return new SongClass();
	}
}
