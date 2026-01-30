package frontend.play.stages.storymode;

import backend.Song.SwagSong;

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
		add(stageCurtains);
	}

	override function countdownTick(tick:Int = 0)
	{
		super.countdownTick(tick);

		if (tick == 4)
			stageCurtains.playAnim('open');
	}
}
