package koya.backend.songs;

import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import koya.frontend.scenes.play.PlayState;

using StringTools;

class EventParser
{
	public static final splitText:String = '/';

	public static var subtitles:FlxTypedGroup<FlxText>;
	public static var subtitleTweens:Array<FlxTween> = [];

	public static function init()
	{
		subtitles = new FlxTypedGroup<FlxText>();
		subtitleTweens = [];
		subtitles.cameras = [PlayState.instance.camHUD];
		PlayState.instance.add(subtitles);
	}

	public static function sendEvent(name:String, value:String)
	{
		name = name.toLowerCase();
		var vals:Array<String> = value.split(splitText);

		if (name == 'playanim') playAnim(vals);

		if (name == 'subtitle') subtitle(vals);
		if (name == 'removesubtitles') subtitle(vals);

		for (twn in subtitleTweens)
			if (!twn.active) twn.active = true;
	}

	public static function subtitle(values:Array<String>)
	{
		var text:String = values[0];
		var addBeat:Null<Int> = Std.parseInt(values[1] ?? '0');
		var addStep:Null<Int> = Std.parseInt(values[2] ?? '0');
		var visibleFor:Null<Int> = Std.parseInt(values[3] ?? null);
		var fadeTime:Float = (Conductor.stepCrochet * (addStep ?? 0) + ((addBeat ?? 0) * 4)) / 1000;

		if (text.trim() == '') return;

		var newText:FlxText = new FlxText();
		newText.font = AssetPaths.font('vcr.ttf');
		newText.size = 32;
		newText.text = text;

		newText.screenCenter(X);

		newText.y = PlayState.instance.healthBar.y - (newText.height * 2);
		newText.scrollFactor.set();

		newText.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);

		for (text in subtitles.members)
			text.y -= newText.height;

		subtitles.add(newText);
		var tweenNumber = subtitleTweens.length;
		var delay = ((Conductor.crochet * (visibleFor ?? 2)) / 1000);

		var THESTUPIDPIECEOFSHIT:FlxTween = null;

		THESTUPIDPIECEOFSHIT = FlxTween.tween(newText, {alpha: 0}, fadeTime,
			{
				ease: FlxEase.quadInOut,
				// last for 2 (default) beats then fades
				startDelay: delay,
				onComplete: function(t) {
					subtitles.members.remove(newText);
					newText.destroy();

					subtitleTweens.remove(THESTUPIDPIECEOFSHIT);
					THESTUPIDPIECEOFSHIT.destroy();
				},
				onStart: function(t) {
					trace('started fadin sub("$text") for ${fadeTime}s after ${delay}s');
				}
			});

		subtitleTweens.push(THESTUPIDPIECEOFSHIT);

		// trace(text);
		// trace(fadeTime);
		// trace(delay);
	}

	public static function removesubtitles(values:Array<String>)
	{
		for (tween in subtitleTweens)
		{
			subtitleTweens.remove(tween);
			tween.destroy();
		}
		for (text in subtitles.members)
		{
			subtitles.members.remove(text);
			text.destroy();
		}
	}

	public static function playAnim(values:Array<String>)
	{
		var character:String = values[0];
		var animationName:String = values[1];

		switch (character)
		{
			case '0', 'bf', 'boy', 'boyfriend', 'player':
				PlayState.instance.currentStage.boyfriend?.playAnim(animationName);
			case '1', 'dad', 'opponent':
				PlayState.instance.currentStage.dad?.playAnim(animationName);
			case '2', 'gf', 'girl', 'girlfriend', 'damsel':
				PlayState.instance.currentStage.gf?.playAnim(animationName);
		}
	}

	public static function pause()
	{
		for (twn in subtitleTweens)
			twn.active = false;
	}

	public static function unpause()
	{
		for (twn in subtitleTweens)
			twn.active = true;
	}
}
