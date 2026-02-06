package koya.frontend.scenes.menustates.options;

import flixel.util.FlxTimer;
import koya.backend.AssetPaths;
import koya.backend.save.SaveField;
import koya.backend.save.Save;
import flixel.input.keyboard.FlxKey;
import koya.frontend.ui.AtlasText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

using StringTools;

class KeybindPrompt extends MusicBeatSubstate
{
	var promptText:AtlasText;
	var bg:FunkinSprite = new FunkinSprite();
	var colorShit:FunkinSprite = new FunkinSprite();

	var keybind:String;
	var leaveMethod:Void->Void;

	override public function new(keybind:String, ?leaveMethod:Void->Void)
	{
		super();

		this.keybind = keybind;
		this.leaveMethod = leaveMethod;
	}

	override function create()
	{
		super.create();

		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		colorShit.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString('#FF99CC'));
		colorShit.scale.set(0.9, 0.9);
		colorShit.alpha = 0;
		colorShit.scrollFactor.set();
		add(colorShit);

		promptText = new AtlasText(10, 10, 'Binding: ' + '“$keybind”' + '\n\nESCAPE TO CANCEL', BOLD);
		promptText.screenCenter();
		add(promptText);

		promptText.alpha = 0;
		promptText.color = FlxColor.WHITE;

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(colorShit, {alpha: 1}, 0.6, {ease: FlxEase.quartInOut});
		FlxTween.tween(promptText, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK) close();
		else
		{
			if (!FlxG.keys.justReleased.ANY) return;

			var invalids:Array<FlxKey> = [ENTER, BACKSPACE, ESCAPE];

			for (keybind in Save.keybinds)
				invalids.push(FlxKey.fromString(keybind.get()));

			var key:FlxKey = cast FlxG.keys.firstJustReleased();

			if (invalids.contains(key))
			{
				promptText.text = 'Not bound\n\nInvalid Key.';
				deny();
				return;
			}

			var keyString = key.toString();

			var keybindField:SaveField<String> = Reflect.getProperty(Save, keybind);
			if (keybindField == null)
			{
				promptText.text = 'Not bound\n\nInvalid Keybind';
				deny();
				return;
			}

			keybindField.set(keyString);
			promptText.text = 'Bound to “$keyString”';

			accept();
		}
	}

	function accept()
	{
		FlxG.sound.play(AssetPaths.sound('confirmMenu', 'ui'));

		fade();
	}

	function deny()
	{
		FlxG.sound.play(AssetPaths.sound('cancelMenu', 'ui'));

		fade();
	}

	function fade()
	{
		if (leaveMethod != null) leaveMethod();

		FlxTween.tween(bg, {alpha: 0}, 0.75, {ease: FlxEase.quartInOut});
		FlxTween.tween(colorShit, {alpha: 0}, 0.5, {ease: FlxEase.quartInOut});
		FlxTween.tween(promptText, {alpha: 0}, 0.25, {ease: FlxEase.quartInOut});

		FlxTimer.wait(1.0, () -> {
			close();
		});
	}
}
