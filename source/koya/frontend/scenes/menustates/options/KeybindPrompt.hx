package koya.frontend.scenes.menustates.options;

import koya.backend.save.SaveField;
import koya.backend.save.Save;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;

using StringTools;

class KeybindPrompt extends Prompt
{
	var keybind:String;

	override public function new(keybind:String, ?leaveMethod:Bool->Void)
	{
		super(leaveMethod);

		this.keybind = keybind;

		this.prompt = 'Binding: ' + '“${this.keybind}”' + '\n\nESCAPE TO CANCEL';
	}

	override function handleControls()
	{
		super.handleControls();

		var invalids:Array<FlxKey> = [ENTER, BACKSPACE, ESCAPE];

		for (keybind in Save.keybinds)
			invalids.push(FlxKey.fromString(keybind.get()));

		var key:FlxKey = cast FlxG.keys.firstJustReleased();

		if (invalids.contains(key))
		{
			promptText.text = 'Not bound\n\nKey already bound';
			deny();
			return;
		}

		var keyString = key.toString();

		var keybindField:SaveField<String> = Reflect.getProperty(Save, keybind);
		if (keybindField == null)
		{
			promptText.text = 'Not bound\n\nKeybind save field not found';
			deny();
			return;
		}

		keybindField.set(keyString);
		promptText.text = 'Bound to “$keyString”';

		accept();
	}
}
