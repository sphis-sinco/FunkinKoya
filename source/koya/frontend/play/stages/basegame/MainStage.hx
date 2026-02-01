package koya.frontend.play.stages.basegame;

import koya.backend.songs.Song.SwagSong;

class MainStage extends StageBackground
{
	override public function new(song:SwagSong, ?performInit:Bool = true)
	{
		super(song, 'mainStage', performInit);
	}

	public var stageBack:FunkinSprite = new FunkinSprite();
	public var stageFloor:FunkinSprite = new FunkinSprite();
	public var stageCurtains:FunkinSprite = new FunkinSprite();

	override function initBG()
	{
		super.initBG();

		stageBack.loadGraphic(getBGImg('stageBack'));
		stageFloor.loadGraphic(getBGImg('stageFloor'));

		stageBack.scrollFactor.set(0.9, 0.9);
		stageFloor.scrollFactor.set(0.9, 0.9);

		// stageBack.scale.set(2, 2);
		stageFloor.scale.set(1.25, 1.25);

		add(stageBack);
		add(stageFloor);
	}

	override function initFG()
	{
		super.initFG();

		stageCurtains.frames = getBGSparrowImg('stageCurtain');

		stageCurtains.addPrefixAnim('closed', 'curtain closed');
		stageCurtains.addPrefixAnim('open', 'curtain open');
		stageCurtains.playAnim('closed');

		stageCurtains.scrollFactor.set();

		if (PlayState.IS_STORYMODE && PlayState.STORYMODE_PLAYLIST_NUMBER == 0 || !PlayState.IS_STORYMODE) add(stageCurtains);
	}

	override function countdownTick(tick:Int = 0)
	{
		super.countdownTick(tick);

		if (PlayState.IS_STORYMODE
			&& PlayState.STORYMODE_PLAYLIST_NUMBER == 0
			|| !PlayState.IS_STORYMODE) if (tick == 2) stageCurtains.playAnim('open');
	}
}
