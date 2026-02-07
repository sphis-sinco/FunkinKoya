package koya.frontend.scenes.play.stages.basegame;

import koya.backend.songs.Song.SwagSong;

class MainStage extends StageBackground
{
	override public function new(song:SwagSong, ?performInit:Bool = true)
	{
		super(song, 'mainStage', performInit);
	}

	var stageCurtains:FunkinSprite;

	override function init()
	{
		super.init();

		stageCurtains = cast getThing('stageCurtains');
		if (stageCurtains != null) if (PlayState.IS_STORYMODE && PlayState.STORYMODE_PLAYLIST_NUMBER != 0) remove(stageCurtains);
	}

	override function countdownTick(tick:Int = 0)
	{
		super.countdownTick(tick);

		if (tick == 2) try
		{
			stageCurtains?.playAnim('open');
		}
		catch (e)
		{
			trace(e.message);
		}
	}
}
