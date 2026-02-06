package koya.frontend.scenes.menustates.options;

import koya.frontend.ui.AtlasText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

using StringTools;

class KeybindPrompt extends MusicBeatSubstate
{
	var promptText:AtlasText;

	var keybind:String;

	override public function new(keybind:String)
	{
		super();

		this.keybind = keybind;
	}

	override function create()
	{
		super.create();

		var bg:FunkinSprite = new FunkinSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		var colorShit:FunkinSprite = new FunkinSprite();
		colorShit.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		colorShit.scale.set(0.8,0.8);
		colorShit.alpha = 0;
		colorShit.scrollFactor.set();
		add(colorShit);
		FlxTween.tween(colorShit, {alpha: 0.8}, 0.6, {ease: FlxEase.quartInOut});

		promptText = new AtlasText(10, 10, 'Binding: ' + '“$keybind”' + '\n\nESCAPE TO CANCEL', BOLD);
		promptText.screenCenter();
		add(promptText);

		promptText.alpha = 0;
		promptText.color = FlxColor.WHITE;

		FlxTween.tween(promptText, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
	}
}
