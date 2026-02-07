package koya.frontend.ui.menustate;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.sound.FlxSound;
import flixel.effects.FlxFlicker;
import flixel.math.FlxMath;
import koya.backend.Conductor;
import koya.backend.AssetPaths;
import flixel.FlxG;
import koya.frontend.scenes.*;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

enum MenuType
{
	Vertical;
	Horizontal;
}

class MenuState extends MusicBeatState
{
	public var pinkBG:MenuBG = new MenuBG(true);
	public var flashBG:MenuBG = new MenuBG(false);

	public var itemList:Array<String> = [];
	public var itemsSpriteGroup:FlxTypedGroup<MenuItem>;
	public var itemsAtlasTextGroup:FlxTypedGroup<AtlasText>;
	public var itemsFlxTextGroup:FlxTypedGroup<FlxText>;

	public var currentSelection:Int = 0;

	public var menuType:MenuType = Vertical;
	public var menuItemPathPrefix:String = '';
	public var text:Bool = false;
	public var atlasText:Bool = false;

	public var itemStartingPos:Float = 240;
	public var itemIncOffset:Float = 320;

	override public function new(menuItemPathPrefix:String, menuType:MenuType = Vertical)
	{
		super();

		this.menuType = menuType;
		this.menuItemPathPrefix = menuItemPathPrefix;
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

		itemsSpriteGroup = new FlxTypedGroup<MenuItem>();
		add(itemsSpriteGroup);

		itemsAtlasTextGroup = new FlxTypedGroup<AtlasText>();
		add(itemsAtlasTextGroup);

		reloadMenuItems();
	}

	public function reloadMenuItems()
	{
		itemsAtlasTextGroup.clear();
		itemsSpriteGroup.clear();

		var i = 0;
		for (item in itemList)
		{
			if (!text) makeSprite(item, i);
			if (text && atlasText) makeAtlasText(item, i);
			if (text && !atlasText) makeFlxText(item, i);

			i++;
		}

		select();
	}

	public function makeAtlasText(item:String, i:Int)
	{
		var menuItem = new AtlasText((menuType == Horizontal) ? -640 : 0, (menuType == Vertical) ? -640 : 0, item, BOLD);

		if (menuType == Horizontal) menuItem.screenCenter(Y);
		if (menuType == Vertical) menuItem.screenCenter(X);

		menuItem.ID = i;
		itemsAtlasTextGroup.add(menuItem);
	}

	public function makeFlxText(item:String, i:Int)
	{
		var menuItem = new FlxText((menuType == Horizontal) ? -640 : 0, (menuType == Vertical) ? -640 : 0, 0, item, 16);
		menuItem.setFormat(AssetPaths.font('vcr.ttf'), 16, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
		menuItem.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);

		if (menuType == Horizontal) menuItem.screenCenter(Y);
		if (menuType == Vertical) menuItem.screenCenter(X);

		menuItem.ID = i;
		itemsFlxTextGroup.add(menuItem);
	}

	public function makeSprite(item:String, i:Int)
	{
		var menuItem = new MenuItem(item, menuItemPathPrefix, (menuType == Horizontal) ? -640 : 0, (menuType == Vertical) ? -640 : 0);

		menuItem.scale.set(.5, .5);
		menuItem.updateHitbox();
		menuItem.makeOffsets();

		menuItem.playAnim('idle');

		if (menuType == Horizontal) menuItem.screenCenter(Y);
		if (menuType == Vertical) menuItem.screenCenter(X);

		menuItem.ID = i;
		itemsSpriteGroup.add(menuItem);
	}

	public var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (menuType == Vertical)
		{
			if (subState == null && controls.UI_UP_R) select(-1);
			if (subState == null && controls.UI_DOWN_R) select(1);
		}

		if (menuType == Horizontal)
		{
			if (subState == null && controls.UI_LEFT_R) select(-1);
			if (subState == null && controls.UI_RIGHT_R) select(1);
		}

		if (subState == null && controls.ACCEPT)
			accepted((text) ? ((atlasText) ? itemsAtlasTextGroup.members[currentSelection].text : itemsFlxTextGroup.members[currentSelection].text) : itemsSpriteGroup.members[currentSelection].item);
		if (subState == null && controls.BACK) back();

		if (menuType == Vertical)
		{
			pinkBG.screenCenter(X);
			pinkBG.y = FlxMath.lerp(pinkBG.y, (FlxG.height - pinkBG.height) / 2 - (currentSelection * 2), .1);
		}
		else
		{
			pinkBG.screenCenter(Y);
			pinkBG.x = FlxMath.lerp(pinkBG.x, (FlxG.width - pinkBG.width) / 2 - (currentSelection * 2), .1);
		}
		flashBG.setPosition(pinkBG.x, pinkBG.y);

		if (!text) for (menuItem in itemsSpriteGroup.members)
		{
			if (menuType == Horizontal) menuItem.x = FlxMath.lerp(menuItem.x, itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), .1);
			if (menuType == Vertical) menuItem.y = FlxMath.lerp(menuItem.y, itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), .1);
		}

		if (text && atlasText) for (menuItem in itemsAtlasTextGroup.members)
		{
			if (menuType == Horizontal) menuItem.x = FlxMath.lerp(menuItem.x, itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), .1);
			if (menuType == Vertical) menuItem.y = FlxMath.lerp(menuItem.y, itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), .1);
		}

		if (text && !atlasText) for (menuItem in itemsFlxTextGroup.members)
		{
			if (menuType == Horizontal) menuItem.x = FlxMath.lerp(menuItem.x, itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), .1);
			if (menuType == Vertical) menuItem.y = FlxMath.lerp(menuItem.y, itemStartingPos + (itemIncOffset * (menuItem.ID - currentSelection)), .1);
		}

		if ((FlxG.sound.music == null || !FlxG.sound.music.playing) && !transitioning)
		{
			FlxG.sound.playMusic(AssetPaths.music('freakyMenu'), 0.7, false);
			Conductor.changeBPM(102);
		}

		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;
	}

	public function back()
	{
		FlxG.switchState(() -> new TitleState());
	}

	public function select(change:Int = 0)
	{
		currentSelection += change;

		if (currentSelection < 0) currentSelection = itemList.length - 1;
		if (currentSelection >= itemList.length) currentSelection = 0;

		var aSplitterItem = function() {
			select(change);
		}

		if (itemList[currentSelection] == '' || itemList[currentSelection] == null) aSplitterItem();

		if (!text) for (menuItem in itemsSpriteGroup.members)
		{
			if (menuType == Horizontal) menuItem.screenCenter(Y);
			if (menuType == Vertical) menuItem.screenCenter(X);
			menuItem.playAnim('idle');

			if (menuItem.ID == currentSelection) menuItem.playAnim('selected');
		}
		if (text && atlasText) for (menuItem in itemsAtlasTextGroup.members)
		{
			if (menuType == Horizontal) menuItem.screenCenter(Y);
			if (menuType == Vertical) menuItem.screenCenter(X);

			menuItem.alpha = (menuItem.ID == currentSelection) ? 1.0 : 0.6;
		}
		if (text && !atlasText) for (menuItem in itemsFlxTextGroup.members)
		{
			if (menuType == Horizontal) menuItem.screenCenter(Y);
			if (menuType == Vertical) menuItem.screenCenter(X);

			menuItem.alpha = (menuItem.ID == currentSelection) ? 1.0 : 0.6;
		}

		if (change != 0) FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));
	}

	public function accepted(item:String)
	{
		if (item.trim() == '' || item == null) return;

		trace('selected: $item');

		transitioning = true;

		var confirmMenu = new FlxSound().loadEmbedded(AssetPaths.sound('confirmMenu', 'ui'));
		confirmMenu.play();

		acceptedFlicker(confirmMenu, item);
	}

	public function acceptedFlicker(confirmMenu:FlxSound, item:String)
	{
		FlxFlicker.flicker(pinkBG, (confirmMenu.length / 2) / 1000, .1);
		if (!text) FlxFlicker.flicker(itemsSpriteGroup.members[currentSelection], (confirmMenu.length / 2) / 500, .05);
		if (text && atlasText) FlxFlicker.flicker(itemsAtlasTextGroup.members[currentSelection], (confirmMenu.length / 2) / 500, .05);
		if (text && !atlasText) FlxFlicker.flicker(itemsFlxTextGroup.members[currentSelection], (confirmMenu.length / 2) / 500, .05);

		FlxTimer.wait((confirmMenu.length / 2) / 1000, function() {
			transitioning = false;
			accept(item);
		});
	}

	public function accept(item:String)
	{
		if (item.trim() == '' || item == null) return;
	}
}
