package koya.frontend.scenes.play.stages.basegame;

import koya.backend.songs.Song.SwagSong;

class MainStage extends StageBackground
{
	override public function new(song:SwagSong, ?performInit:Bool = true)
	{
		super(song, 'mainStage', performInit);
	}

	override function initFG()
	{
		super.initFG();
	}

	override function countdownTick(tick:Int = 0)
	{
		super.countdownTick(tick);

		if (tick == 2) getThing('stageCurtains')?.playAnim('open');
	}
}
