package koya.frontend.scenes.menustates.options;

import flixel.sound.FlxSound;
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

class Prompt extends MusicBeatSubstate
{
	var promptText:AtlasText;
	var bg:FunkinSprite = new FunkinSprite();
	var colorShit:FunkinSprite = new FunkinSprite();

	var leaveMethod:Void->Void;

	var prompt:String = 'Unknown Prompt';

	override public function new(?leaveMethod:Void->Void)
	{
		super();

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

		promptText = new AtlasText(10, 10, prompt, BOLD);
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

			handleControls();
		}
	}

	function handleControls() {}

	function accept()
	{
		confirmMenu.play(true);

		fade();
	}

	function deny()
	{
		cancelMenu.play(true);

		fade(1.0);
	}

	var cancelMenu = new FlxSound().loadEmbedded(AssetPaths.sound('cancelMenu', 'ui'));
	var confirmMenu = new FlxSound().loadEmbedded(AssetPaths.sound('confirmMenu', 'ui'));

	function fade(longer:Float = 0)
	{
		if (leaveMethod != null) leaveMethod();

		FlxTween.tween(bg, {alpha: 0}, 0.75 + longer, {ease: FlxEase.quartInOut});
		FlxTween.tween(colorShit, {alpha: 0}, 0.5 + longer, {ease: FlxEase.quartInOut});
		FlxTween.tween(promptText, {alpha: 0}, 0.25 + longer, {ease: FlxEase.quartInOut});

		FlxTimer.wait(1.0 + longer, () -> {
			confirmMenu.stop();
			cancelMenu.stop();
			close();
		});
	}
}
