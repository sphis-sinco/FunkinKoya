package koya.backend.controls;

import koya.backend.save.Save;
import koya.backend.controls.Controls;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.input.actions.FlxActionInput;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxSignal;

// import ui.DeviceManager;
// import props.Player;
class PlayerSettings
{
	static public var numPlayers(default, null) = 0;
	static public var numAvatars(default, null) = 0;
	static public var player1(default, null):PlayerSettings;
	static public var player2(default, null):PlayerSettings;

	static public var onAvatarAdd(default, null) = new FlxTypedSignal<PlayerSettings->Void>();
	static public var onAvatarRemove(default, null) = new FlxTypedSignal<PlayerSettings->Void>();

	public var id(default, null):Int;

	public var controls(default, null):Controls;

	// public var avatar:Player;
	// public var camera(get, never):PlayCamera;

	function new(id)
	{
		this.id = id;
		this.controls = new Controls('player$id', None);

		controls.setKeyboardScheme(Solo);
	}

	function addGamepad(gamepad:FlxGamepad)
	{
		controls.addDefaultGamepad(gamepad.id);
	}

	static public function init():Void
	{
		if (player1 == null)
		{
			player1 = new PlayerSettings(0);
			++numPlayers;
		}

		FlxG.gamepads.deviceConnected.add(onGamepadAdded);

		var numGamepads = FlxG.gamepads.numActiveGamepads;
		for (i in 0...numGamepads)
		{
			var gamepad = FlxG.gamepads.getByID(i);
			if (gamepad != null) onGamepadAdded(gamepad);
		}
	}

	static function onGamepadAdded(gamepad:FlxGamepad)
	{
		player1.addGamepad(gamepad);
	}

	static public function reset()
	{
		player1 = null;
		player2 = null;
		numPlayers = 0;
	}
}
