package koya.frontend.mainmenu;

import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.effects.FlxFlicker;
import koya.frontend.freeplay.FreeplayState;
import flixel.math.FlxMath;
import koya.backend.Conductor;
import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

enum MenuType
{
	Vertical;
	Horizontal;
}

class MainMenuState extends MusicBeatState
{
	public var pinkBG:MenuBG = new MenuBG(true);
	public var flashBG:MenuBG = new MenuBG(false);

	public var itemList:Array<String> = [
		'story mode',
		'freeplay',
		'support',
		// 'options',
	];
	public var itemsGroup:FlxTypedGroup<MenuItem>;

	public var currentSelection:Int = 0;

	public var menuType:MenuType = Vertical;

	public var itemStartingPos:Float = 240;
	public var itemIncOffset:Float = 320;

	override public function new(menuType:MenuType = Horizontal)
	{
		super();

		this.menuType = menuType;
	}

	override function create()
	{
		super.create();

		flashBG.color = 0x645B9A;
		add(flashBG);
		add(pinkBG);

		flashBG.scale.set(.75, .75);
		pinkBG.scale.set(.75, .75);

		flashBG.updateHitbox();
		pinkBG.updateHitbox();

		itemsGroup = new FlxTypedGroup<MenuItem>();
		add(itemsGroup);

		var i = 0;
		for (item in itemList)
		{
			var menuItem = new MenuItem(item, (menuType == Horizontal) ? -640 : 0, (menuType == Vertical) ? -640 : 0);

			menuItem.scale.set(.5, .5);
			menuItem.updateHitbox();
			menuItem.makeOffsets();

			menuItem.playAnim('idle');

			if (menuType == Horizontal) menuItem.screenCenter(Y);
			if (menuType == Vertical) menuItem.screenCenter(X);

			menuItem.ID = i;
			itemsGroup.add(menuItem);

			i++;
		}

		select();
	}

	public var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (menuType == Vertical)
		{
			if (controls.UI_UP_R) select(-1);
			if (controls.UI_DOWN_R) select(1);
		}

		if (menuType == Horizontal)
		{
			if (controls.UI_LEFT_R) select(-1);
			if (controls.UI_RIGHT_R) select(1);
		}

		if (controls.ACCEPT) accepted(itemsGroup.members[currentSelection].item);
		if (controls.BACK) FlxG.switchState(() -> new TitleState());

		if (menuType == Vertical)
		{
			pinkBG.screenCenter(X);
			pinkBG.y = FlxMath.lerp((FlxG.height - pinkBG.height) / 2 - (currentSelection * 2), pinkBG.y, 0.9);
		}
		else
		{
			pinkBG.screenCenter(Y);
			pinkBG.x = FlxMath.lerp((FlxG.width - pinkBG.width) / 2 - (currentSelection * 2), pinkBG.x, 0.9);
		}
		flashBG.setPosition(pinkBG.x, pinkBG.y);

		for (menuItem in itemsGroup.members)
		{
			if (menuType == Horizontal) menuItem.x = FlxMath.lerp(itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), menuItem.x, 0.9);
			if (menuType == Vertical) menuItem.y = FlxMath.lerp(itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), menuItem.y, 0.9);
		}

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
		if (change != 0) FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));

		if (currentSelection < 0) currentSelection = 0;
		if (currentSelection >= itemList.length) currentSelection = itemList.length - 1;

		for (menuItem in itemsGroup.members)
		{
			if (menuType == Horizontal) menuItem.screenCenter(Y);
			if (menuType == Vertical) menuItem.screenCenter(X);
			menuItem.playAnim('idle');

			if (menuItem.ID == currentSelection) menuItem.playAnim('selected');
		}
	}

	public function accepted(item:String)
	{
		trace('selected: $item');

		transitioning = true;

		var confirmMenu = new FlxSound().loadEmbedded(AssetPaths.sound('confirmMenu', 'ui'));
		confirmMenu.play();

		FlxFlicker.flicker(pinkBG, (confirmMenu.length / 2) / 1000, .1);
		FlxFlicker.flicker(itemsGroup.members[currentSelection], (confirmMenu.length / 2) / 500, .05);

		FlxTimer.wait((confirmMenu.length / 2) / 1000, function() {
			transitioning = false;
			accept(item);
		});
	}

	public function accept(item:String)
	{
		switch (item)
		{
			case 'story mode':
				trace('the tale you play');
			case 'freeplay':
				trace('FREE');
				FlxG.switchState(() -> new FreeplayState());
				transitioning = true;
			case 'support':
				trace('mone?');
				FlxG.openURL('https://ko-fi.com/sphis');
			case 'options':
				trace('change is supported');
		}
	}
}
