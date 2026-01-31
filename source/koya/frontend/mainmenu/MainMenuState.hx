package koya.frontend.mainmenu;

class MainMenuState extends MusicBeatState {

	public var pinkBG:MenuBG = new MenuBG(true);
	public var flashBG:MenuBG = new MenuBG(false);

	override function create() {
		super.create();

		flashBG.color = 0x645B9A;
		add(flashBG);
		add(pinkBG);

		flashBG.screenCenter();
		pinkBG.screenCenter();

		flashBG.scale.set(.75, .75);
		pinkBG.scale.set(.75, .75);

		flashBG.scrollFactor.set(0, .1);
		pinkBG.scrollFactor.set(0, .1);
	}
}
