package frontend.play.stages.storymode;

class MainStage extends StageBackground
{
	override function initInfo()
	{
		super.initInfo();

		PlayState.SONG_STAGE = 'MainStage';
		// PlayState.instance.defaultCamZoom = 1.05;
	}
}
