package frontend.play.stages;

import backend.Song.SwagSong;

class StageBackgroundGetter
{
	public static function getStage(song:SwagSong, ?stage:String = 'mainStage'):StageBackground
	{
		return new StageBackground(song);
	}
}
