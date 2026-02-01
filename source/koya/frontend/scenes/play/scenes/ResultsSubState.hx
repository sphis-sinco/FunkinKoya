package koya.frontend.scenes.play.scenes;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import koya.backend.Conductor;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.util.typeLimit.NextState;

class ResultsSubState extends MusicBeatSubstate
{
	public var nextState:NextState;

	override public function new(nextState:NextState)
	{
		super();

		this.nextState = nextState;
	}

	public var back:FunkinSprite;

	public var resultsCam:FlxCamera;

	override function create()
	{
		super.create();

		back = new FunkinSprite();
		back.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString('#FFFF00'));
		add(back);

		resultsCam = new FlxCamera(0, 0, 1280, 720);
		add(resultsCam);

		back.cameras = [resultsCam];

		resultsCam.bgColor.alpha = 0;
		FlxG.cameras.add(resultsCam);

		back.y -= back.height;
		back.alpha = 0;
		FlxTween.tween(back, {y: 0, alpha: 1}, (Conductor.crochet / 1000) * 4, {
			ease: FlxEase.quadInOut
		});
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.ACCEPT && back.alpha == 1)
			FlxG.switchState(nextState);
	}
}
