package koya.frontend.scenes.menustates.options;

import koya.backend.AssetPaths;
import flixel.FlxG;
import koya.backend.save.Save;

using StringTools;

class ControlRemap extends OptionsMenuState
{
	public var altMod:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (subState == null && (controls.UI_LEFT_R || controls.UI_RIGHT_R))
		{
			FlxG.sound.play(AssetPaths.sound('scrollMenu', 'ui'));

			altMod = !altMod;

			reloadItems();
			reloadMenuItems();
		}

		valueText.text += '\n\n( Toggle alts via UI_LEFT or UI_RIGHT )';
		valueText.y = valueBG.getGraphicMidpoint().y - (valueText.height / 2);
	}

	override function addItems()
	{
		addItem('Leave', 'Select this to return to the regular options menu', back);

		var stringKeybinds:Array<String> = [];
		for (keybind in Save.keybinds)
			if (keybind != null) stringKeybinds.push(keybind.field);

		for (keybind in Save.keybinds)
		{
			if (keybind == null)
			{
				addItem(null, null, null);
				continue;
			}

			if (stringKeybinds.contains('${keybind.field}_alt')
				|| stringKeybinds.contains(keybind.field.substr(0, keybind.field.length - 4)))
			{
				if (keybind.field.endsWith('_alt') && !altMod) continue;
				if (!keybind.field.endsWith('_alt') && altMod) continue;
			}

			addItem(keybind.display ?? keybind.field, keybind.get(), function() {
				persistentUpdate = true;
				openSubState(new KeybindPrompt(keybind.field, function(confirm:Bool) {
					reloadItems();
					controls.setKeyboardScheme(Custom);
				}));
			});
		}
	}

	override function back()
	{
		FlxG.switchState(() -> new OptionsMenuState());
	}
}
