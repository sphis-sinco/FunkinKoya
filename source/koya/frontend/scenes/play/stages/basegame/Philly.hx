package koya.frontend.scenes.play.stages.basegame;

import koya.backend.songs.Song.SwagSong;

class Philly extends StageBackground
{
	override public function new(song:SwagSong, ?performInit:Bool = true)
	{
		super(song, 'philly', performInit);
	}

	public var bridge:FunkinSprite = new FunkinSprite();
	public var buildings:FunkinSprite = new FunkinSprite();
	public var floor:FunkinSprite = new FunkinSprite();
	public var gradient:FunkinSprite = new FunkinSprite();

	override function initInfo()
	{
		super.initInfo();

		PlayState.instance.defaultCamZoom = 0.8;
	}

	override function initBG()
	{
		super.initBG();

		bridge.loadGraphic(getBGImg('bridge ws'));
		bridge.scale.set(2,2);
		bridge.updateHitbox();
		
		buildings.loadGraphic(getBGImg('buildings'));
		
		floor.loadGraphic(getBGImg('floor'));
		floor.scale.set(2,2);
		floor.updateHitbox();

		gradient.loadGraphic(getBGImg('gradient.png'));
		gradient.scrollFactor.set(0,0);

		add(gradient);
		add(buildings);
		add(bridge);
		add(floor);
	}
}
