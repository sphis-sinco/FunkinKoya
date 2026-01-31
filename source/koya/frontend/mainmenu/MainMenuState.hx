package koya.frontend.mainmenu;

import flixel.group.FlxGroup.FlxTypedGroup;

class MainMenuState extends MusicBeatState
{
	public var pinkBG:MenuBG = new MenuBG(true);
	public var flashBG:MenuBG = new MenuBG(false);

	public var menuItemsList:Array<String> = ['story mode', 'freeplay'];
	public var menuItemsGroup:FlxTypedGroup<MenuItem>;

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
			var menuItem = new MenuItem(item, 0, 40 + (180 * i));
			menuItem.screenCenter(X);

			menuItem.ID = i;
			menuItemsGroup.add(menuItem);
			
			i++;
		}
	}
}
