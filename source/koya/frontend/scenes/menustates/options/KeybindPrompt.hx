package koya.frontend.scenes.menustates.options;

import koya.frontend.ui.Alphabet;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;

class KeybindPrompt extends MusicBeatSubstate
{
	var promptText:Alphabet;

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

		promptText = new Alphabet(0, 0, 'Press anything to bind "$keybind"');
		promptText.screenCenter();
		add(promptText);
	}
}
