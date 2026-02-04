package koya.backend.songs;

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
		PlayState.instance.add(subtitles);
	}

	public static function sendEvent(name:String, value:String)
	{
		name = name.toLowerCase();
		var vals:Array<String> = value.split(splitText);

		if (name == 'playanim') playAnim(vals);

		if (name == 'subtitle') subtitle(vals);
		if (name == 'removesubtitles') subtitle(vals);
	}

	public static function subtitle(values:Array<String>)
	{
		var text:String = values[0];
		var tilBeat:Null<Int> = Std.parseInt((values[1].trim() != '') ? values[1] : '0');
		var tilStep:Null<Int> = Std.parseInt((values[2].trim() != '') ? values[2] : '0');
		var visibleFor:Null<Int> = Std.parseInt((values[3].trim() != '') ? values[3] : null);

		if (text.trim() == '') return;

		var newText:FlxText = new FlxText();
		newText.font = AssetPaths.font('vcr.ttf');
		newText.size = 16;
		newText.text = text;

		newText.screenCenter(X);

		newText.y = PlayState.instance.healthBar.y - newText.height;

		for (text in subtitles.members)
			text.y -= newText.height;

		subtitles.add(newText);

		var timeAddition:Float = ((Conductor.stepCrochet / 1000) * (tilStep + (tilBeat * 4)));

		subtitleTweens.push(FlxTween.tween(newText, {alpha: 1}, Conductor.songPosition + timeAddition,
			{
				ease: FlxEase.quadInOut,
				startDelay: (Conductor.crochet / 1000) * (visibleFor ?? 2) // last for 2 (default) beats then fades
			}));
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

	public static function pause() {}

	public static function unpause() {}
}
