package backend;

import frontend.play.stages.storymode.MainStage;
import backend.AssetPaths;
import backend.Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

using StringTools;

typedef ChartSwagSong =
{
	var song:SwagSong;
}

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var validScore:Bool;

	var ?gfVersion:String;
	var ?stage:String;

	var ?authors:String;

	var ?version:Null<Int>;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong
	{
		var rawJson:String = '';
		try
		{
			rawJson = Assets.getText(AssetPaths.chart(folder, jsonInput)).trim();
		}
		catch (e)
		{
			trace(e);
			// rawJson = Json.stringify({song: dummySong});
			return null;
		}

		while (!rawJson.endsWith("}"))
			rawJson = rawJson.substr(0, rawJson.length - 1);

		return parseJSONshit(Json.parse(rawJson));
	}

	public static function parseJSONshit(rawJson:ChartSwagSong):SwagSong
	{
		if (rawJson == null)
			return null;

		var swagShit:SwagSong = rawJson.song;
		swagShit.validScore = true;

		swagShit.version ??= 0;

		fixSwagVersion(swagShit);

		return swagShit;
	}

	public static function fixSwagVersion(swagShit:SwagSong)
	{
		switch (swagShit.version)
		{
			case 0:
				swagShit.gfVersion = dummySong.gfVersion;
			case 1:
				swagShit.stage = dummySong.stage;
			case 2:
				swagShit.authors = 'Unknown';
		}

		if (swagShit.version < SWAGVERSION)
		{
			swagShit.version += 1;
			fixSwagVersion(swagShit);
		}
	}

	public static var SWAGVERSION:Int = 3;

	public static var dummySong:SwagSong = {
		song: 'Test',
		notes: [],
		bpm: 150,
		needsVoices: true,
		player1: 'bf',
		player2: 'dad',
		speed: 1,
		validScore: false,
		gfVersion: 'gf',
		stage: new MainStage(null, false).BG_NAME,
		authors: 'Kawai Sprite (ft. MtH)',
		version: SWAGVERSION
	}
}
