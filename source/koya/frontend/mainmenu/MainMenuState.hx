package koya.frontend.mainmenu;

import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.effects.FlxFlicker;
import koya.frontend.freeplay.FreeplayState;
import flixel.math.FlxMath;
import flixel.FlxObject;
import koya.backend.Conductor;
import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;

class MainMenuState extends MusicBeatState
{
	public var pinkBG:MenuBG = new MenuBG(true);
	public var flashBG:MenuBG = new MenuBG(false);

	public var menuItemsList:Array<String> = [
		'story mode',
		'freeplay',
		// 'support',
		// 'options',
	];
	public var menuItemsGroup:FlxTypedGroup<MenuItem>;

	public var currentSelection:Int = 0;

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

		menuItemsGroup = new FlxTypedGroup<MenuItem>();
		add(menuItemsGroup);

		var i = 0;
		for (item in menuItemsList)
		{
			var menuItem = new MenuItem(item, 0, -640);

			menuItem.scale.set(.5, .5);
			menuItem.updateHitbox();
			menuItem.makeOffsets();

			menuItem.playAnim('idle');

			menuItem.screenCenter(X);

			menuItem.ID = i;
			menuItemsGroup.add(menuItem);

			i++;
		}

		select();
	}

	public var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		pinkBG.screenCenter(X);
		pinkBG.y = FlxMath.lerp((FlxG.height - pinkBG.height) / 2 - (currentSelection * 2), pinkBG.y, 0.9);
		flashBG.setPosition(pinkBG.x, pinkBG.y);

		for (menuItem in menuItemsGroup.members)
			menuItem.y = FlxMath.lerp(240 + (320 * (menuItem.ID - currentSelection)), menuItem.y, 0.9);

		if (controls.UI_UP_R) select(-1);
		if (controls.UI_DOWN_R) select(1);

		if (controls.ACCEPT) accepted(menuItemsGroup.members[currentSelection].item);
		if (controls.BACK) FlxG.switchState(() -> new TitleState());

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
		if (currentSelection >= menuItemsList.length) currentSelection = menuItemsList.length - 1;

		for (menuItem in menuItemsGroup.members)
		{
			menuItem.screenCenter(X);
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
		FlxFlicker.flicker(menuItemsGroup.members[currentSelection], (confirmMenu.length / 2) / 500, .05);

		FlxTimer.wait((confirmMenu.length / 2) / 1000, function() {
			switch (item)
			{
				case 'story mode':
					trace('the tale you play');
				case 'freeplay':
					trace('FREE');
					FlxG.switchState(() -> new FreeplayState());
				case 'support':
					trace('mone?');
					FlxG.openURL('https://ko-fi.com/sphis');
				case 'options':
					trace('change is supported');
			}
			transitioning = false;
		});
	}
}
