package koya.frontend.mainmenu;

import flixel.FlxObject;
import koya.backend.Conductor;
import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class MainMenuState extends MusicBeatState
{
	public var pinkBG:MenuBG = new MenuBG(true);
	public var flashBG:MenuBG = new MenuBG(false);

	public var menuItemsList:Array<String> = ['story mode', 'freeplay'];
	public var menuItemsGroup:FlxTypedGroup<MenuItem>;

	public var currentSelection:Int = 0;

	public var camFollow:FlxObject;

	override function create()
	{
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

		menuItemsGroup = new FlxTypedGroup<MenuItem>();
		add(menuItemsGroup);

		var i = 0;
		for (item in menuItemsList)
		{
			var menuItem = new MenuItem(item, 0, 40 + (480 * i));

			menuItem.playAnim('idle');

			menuItem.screenCenter(X);

			menuItem.ID = i;
			menuItemsGroup.add(menuItem);

			i++;
		}

		camFollow = new FlxObject(0, 0, 1280, 720);
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 0.1);

		select();
	}

	public var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UI_UP_R) select(-1);
		if (controls.UI_DOWN_R) select(1);

		if ((FlxG.sound.music == null || !FlxG.sound.music.playing) && !transitioning)
		{
			FlxG.sound.playMusic(AssetPaths.music('freakyMenu'), 0.7, false);
			Conductor.changeBPM(102);
		}

		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;
	}

	public function select(change:Int = 0)
	{
		currentSelection += change;
		if (change > 0) FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));

		if (currentSelection < 0) currentSelection = 0;
		if (currentSelection >= menuItemsList.length) currentSelection = menuItemsList.length - 1;

		for (menuItem in menuItemsGroup.members)
		{
			menuItem.screenCenter(X);
			menuItem.playAnim('idle');

			if (menuItem.ID == currentSelection)
			{
				menuItem.playAnim('selected');
				camFollow.y = (menuItem.getGraphicMidpoint().y);
			}
		}
	}
}
