package frontend.play.songs.week1;

class BopeeboScript extends SongClass
{
	override public function beatHit(beat:Int)
	{
		if (beat >= 128 && beat < 131)
			PlayState.instance.vocals.volume = 0;

		if (beat % 8 == 7)
			PlayState.instance.currentStage.boyfriend?.playAnim('hey', true);
	}
}
