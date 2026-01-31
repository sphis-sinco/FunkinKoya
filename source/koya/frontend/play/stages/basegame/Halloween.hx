package koya.frontend.play.stages.basegame;

import koya.backend.songs.Song.SwagSong;

class Halloween extends StageBackground
{
	override public function new(song:SwagSong, ?performInit:Bool = true)
	{
		super(song, 'halloween', performInit);
	}

	public var halloweenBack:FunkinSprite = new FunkinSprite();
	public var stairs:FunkinSprite = new FunkinSprite();

	override function initInfo()
	{
		super.initInfo();

		PlayState.instance.defaultCamZoom = 0.8;
	}

	override function initBG()
	{
		super.initBG();

		halloweenBack.loadGraphic(getBGImg('halloweenBack'));
		add(halloweenBack);
		halloweenBack.scale.set(halloweenBack.width / 2462.3, halloweenBack.height / 1589.95);
	}

	override function initFG()
	{
		super.initFG();

		stairs.loadGraphic(getBGImg('stairs'));
		add(stairs);
	}
}
