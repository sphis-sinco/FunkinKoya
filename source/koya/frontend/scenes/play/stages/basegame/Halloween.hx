package koya.frontend.scenes.play.stages.basegame;

import koya.backend.songs.Song.SwagSong;

class Halloween extends StageBackground
{
	override public function new(song:SwagSong, ?performInit:Bool = true)
	{
		super(song, 'halloween', performInit);
	}

	override function initInfo()
	{
		super.initInfo();

		PlayState.instance.defaultCamZoom = 0.8;
	}

	override function init()
	{
		super.init();

		var halloweenBack:FunkinSprite = cast getThing('halloweenBack');
		if (halloweenBack != null) halloweenBack.scale.set(2462.3 / halloweenBack.width, 1589.95 / halloweenBack.height);
	}

	override function moveCamera(bf:Bool)
	{
		super.moveCamera(bf);

		if (bf) PlayState.instance.camFollow.x -= 120;
	}
}
