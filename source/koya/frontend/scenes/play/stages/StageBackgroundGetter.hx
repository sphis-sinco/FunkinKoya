package koya.frontend.scenes.play.stages;

import koya.frontend.scenes.play.stages.basegame.*;
import koya.backend.songs.Song.SwagSong;

class StageBackgroundGetter
{
	public static function getStage(song:SwagSong, ?stage:String = 'mainstage', ?performInit:Bool = true):StageBackground
	{
		switch (stage.toLowerCase())
		{
			case 'mainstage':
				return new MainStage(song, performInit);
			case 'halloween':
				return new Halloween(song, performInit);
			case 'philly':
				return new Philly(song, performInit);
		}

		return new StageBackground(song, 'Unknown', performInit);
	}
}
