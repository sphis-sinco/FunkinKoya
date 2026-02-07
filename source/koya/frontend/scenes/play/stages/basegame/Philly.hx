package koya.frontend.scenes.play.stages.basegame;

import koya.backend.songs.Song.SwagSong;

class Philly extends StageBackground
{
	override public function new(song:SwagSong, ?performInit:Bool = true)
	{
		super(song, 'philly', performInit);
	}

	override function initInfo()
	{
		super.initInfo();

		PlayState.instance.defaultCamZoom = 0.8;
	}
}
