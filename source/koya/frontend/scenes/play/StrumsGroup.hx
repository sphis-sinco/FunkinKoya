package koya.frontend.scenes.play;

import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

class StrumsGroup extends FlxTypedGroup<FlxBasic>
{
	public var opponentStrums:FlxTypedGroup<FunkinSprite>;
	public var playerStrums:FlxTypedGroup<FunkinSprite>;

	override public function new()
	{
		super();

		opponentStrums = new FlxTypedGroup<FunkinSprite>();
		add(opponentStrums);

		playerStrums = new FlxTypedGroup<FunkinSprite>();
		add(playerStrums);
	}

	override function get_cameras():Array<FlxCamera>
	{
		return playerStrums.cameras;
	}

	override function set_cameras(cameras:Array<FlxCamera>):Array<FlxCamera>
	{
		opponentStrums.cameras = cameras;
		playerStrums.cameras = cameras;

		return cameras;
	}
}
