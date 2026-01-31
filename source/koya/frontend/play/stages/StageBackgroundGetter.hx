package koya.frontend.play.stages;

import koya.frontend.play.stages.basegame.MainStage;
import koya.backend.songs.Song.SwagSong;

class StageBackgroundGetter
{
	public static function getStage(song:SwagSong, ?stage:String = 'mainstage'):StageBackground
	{
		switch (stage.toLowerCase())
		{
			case 'mainstage':
				return new MainStage(song);
		}

		return new StageBackground(song);
	}
}
