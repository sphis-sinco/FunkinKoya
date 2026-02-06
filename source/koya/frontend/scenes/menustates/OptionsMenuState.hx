package koya.frontend.scenes.menustates;

import koya.frontend.scenes.menustates.options.KeybindPrompt;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.sound.FlxSound;
import koya.backend.save.Save;
import koya.backend.AssetPaths;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import koya.frontend.ui.menustate.MenuState;

using StringTools;

class OptionsMenuState extends MenuState
{
	public var itemListValues:Map<String, Dynamic> = [];
	public var itemListFunctions:Map<String, Dynamic> = [];

	public function addItem(item:String, value:Dynamic, method:Dynamic)
	{
		this.itemList.push(item);

		if (item != null && value != null) this.itemListValues.set(item, value);
		if (item != null && method != null) this.itemListFunctions.set(item, method);
	}

	override public function new()
	{
		super('', Vertical);

		this.itemIncOffset = 80;

		reloadItems();

		this.text = true;
	}

	var valueBG:FunkinSprite;
	var valueText:FlxText;

	override function create()
	{
		super.create();

		valueBG = new FunkinSprite();
		valueBG.makeGraphic(FlxG.width, Math.round(FlxG.height / 4), FlxColor.BLACK);
		add(valueBG);

		valueBG.screenCenter();
		valueBG.y = FlxG.height - valueBG.height;

		valueBG.alpha = 0.6;

		valueText = new FlxText(valueBG.x, valueBG.y, valueBG.width, 'Lorem', 32);
		add(valueText);
		valueText.setFormat(AssetPaths.font('vcr.ttf'), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		valueText.borderSize = 3;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		valueText.text = '${this.itemList[currentSelection]} : ${this.itemListValues.get(this.itemList[currentSelection])}';
		valueText.y = valueBG.getGraphicMidpoint().y - (valueText.height / 2);
	}

	override function accept(item:String)
	{
		super.accept(item);

		runMethods(item);
	}

	function runMethods(item:String)
	{
		if (itemListFunctions.exists(item))
		{
			itemListFunctions.get(item)();
			reloadItems();
		}
	}

	function reloadItems()
	{
		this.itemList = [];
		this.itemListValues = [];

		addItems();
	}

	function addItems()
	{
		addItem('FPS Counter', Save.preferences.get().fpsCounter, function() {
			Save.preferences.get().fpsCounter = !Save.preferences.get().fpsCounter;
		});

		addItem(null, null, null);

		addItem('Chart Editor Autosave', Save.preferences.get().chartEditorAutosave, function() {
			Save.preferences.get().chartEditorAutosave = !Save.preferences.get().chartEditorAutosave;
		});

		addItem(null, null, null);

		for (keybind in Save.keybinds)
		{
			if (keybind == null) continue;

			addItem(keybind.field, keybind.get(), function() {
				persistentUpdate = true;
				openSubState(new KeybindPrompt(keybind.field, reloadItems));
			});
		}
	}

	override function acceptedFlicker(confirmMenu:FlxSound, item:String)
	{
		FlxFlicker.flicker(pinkBG, (confirmMenu.length / 4) / 1000, .1);
		if (!text) FlxFlicker.flicker(itemsSpriteGroup.members[currentSelection], (confirmMenu.length / 4) / 500, .05);
		if (text) FlxFlicker.flicker(itemsTextGroup.members[currentSelection], (confirmMenu.length / 4) / 500, .05);

		FlxTimer.wait((confirmMenu.length / 4) / 1000, function() {
			transitioning = false;
			accept(item);
		});
	}

	override function back()
	{
		FlxG.switchState(() -> new MainMenuState());
	}
}
