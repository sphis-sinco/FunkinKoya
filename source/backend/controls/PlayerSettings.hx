package backend.controls;

import backend.save.Save;
import backend.controls.Controls;
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

		#if CLEAR_INPUT_SAVE
		Save.controls.set(null);
		Save.flush();
		#end

		var useDefault = true;
		var controlData = Save.controls.get();
		if (controlData != null)
		{
			var keyData:Dynamic = null;
			if (id == 0 && controlData.p1 != null && controlData.p1.keys != null)
				keyData = controlData.p1.keys;
			else if (id == 1 && controlData.p2 != null && controlData.p2.keys != null)
				keyData = controlData.p2.keys;

			if (keyData != null)
			{
				useDefault = false;
				trace("loaded key data: " + haxe.Json.stringify(keyData));
				controls.fromSaveData(keyData, Keys);
			}
		}

		if (useDefault)
			controls.setKeyboardScheme(Solo);
	}

	function addGamepad(gamepad:FlxGamepad)
	{
		var useDefault = true;
		var controlData = Save.controls.get();
		if (controlData != null)
		{
			var padData:Dynamic = null;
			if (id == 0 && controlData.p1 != null && controlData.p1.pad != null)
				padData = controlData.p1.pad;
			else if (id == 1 && controlData.p2 != null && controlData.p2.pad != null)
				padData = controlData.p2.pad;

			if (padData != null)
			{
				useDefault = false;
				trace("loaded pad data: " + haxe.Json.stringify(padData));
				controls.addGamepadWithSaveData(gamepad.id, padData);
			}
		}

		if (useDefault)
			controls.addDefaultGamepad(gamepad.id);
	}

	public function saveControls()
	{
		if (Save.controls.get() == null)
			Save.controls.set({});

		var playerData:{?keys:Dynamic, ?pad:Dynamic}
		if (id == 0)
		{
			if (Save.controls.get().p1 == null)
				Save.controls.get().p1 = {};
			playerData = Save.controls.get().p1;
		}
		else
		{
			if (Save.controls.get().p2 == null)
				Save.controls.get().p2 = {};
			playerData = Save.controls.get().p2;
		}

		var keyData = controls.createSaveData(Keys);
		if (keyData != null)
		{
			playerData.keys = keyData;
			trace("saving key data: " + haxe.Json.stringify(keyData));
		}

		if (controls.gamepadsAdded.length > 0)
		{
			var padData = controls.createSaveData(Gamepad(controls.gamepadsAdded[0]));
			if (padData != null)
			{
				trace("saving pad data: " + haxe.Json.stringify(padData));
				playerData.pad = padData;
			}
		}

		Save.flush();
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
			if (gamepad != null)
				onGamepadAdded(gamepad);
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
