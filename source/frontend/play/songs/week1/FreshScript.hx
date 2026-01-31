package frontend.play.songs.week1;

class FreshScript extends SongClass
{
	public function beatHit(args:Map<String, Dynamic>)
	{
		var beat:Int = args.get('beat');

		switch (beat)
		{
			case 16:
				PlayState.instance.camZooming = true;
				PlayState.instance.gfSpeed = 2;
			case 48, 112:
				PlayState.instance.gfSpeed = 1;
			case 80:
				PlayState.instance.gfSpeed = 2;
		}
	}

	public function moveCamera(args:Map<String, Dynamic>):Bool
	{
		if (PlayState.instance.curBeat < 16)
			return false;

		return true;
	}
}
