package frontend.play.stages.storymode;

import flixel.tweens.FlxEase;
import backend.Conductor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
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

		add(stageCurtains);
	}

	override function countdownTick(tick:Int = 0)
	{
		super.countdownTick(tick);

		if (tick == 2)
			stageCurtains.playAnim('open');

		if (PlayState.instance != null)
			if (startingCamPos != null)
				PlayState.instance.camFollow.setPosition(startingCamPos.x, startingCamPos.x);
	}

	override function setCamera()
	{
		if (startingCamPos == null)
			super.setCamera();
	}

	override function moveCamera(bf:Bool)
	{
		super.moveCamera(bf);

		if (!bf)
		{
			if (PlayState.instance.curSong == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
		else
		{
			if (PlayState.instance.curSong == 'tutorial')
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
		}
	}
}
