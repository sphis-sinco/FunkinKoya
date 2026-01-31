package koya.backend.songs;

import koya.backend.play.Difficulty;
import koya.frontend.play.stages.basegame.MainStage;
import koya.backend.AssetPaths;
import koya.backend.Section.SwagSection;
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

	// @:deprecated("Unused and unrequired")
	// var validScore:Bool;
	var ?gfVersion:String;
	var ?stage:String;
	var ?authors:String;
	var ?difficulty:Difficulty;
	var ?generatedBy:String;

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

	public static function loadFromJson(jsonInput:String, ?folder:String, fix:Bool = true):SwagSong
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

		return parseJSONshit(Json.parse(rawJson), fix);
	}

	public static function parseJSONshit(rawJson:ChartSwagSong, fix:Bool = true):SwagSong
	{
		if (rawJson == null) return null;

		var swagShit:SwagSong = rawJson.song;

		if (fix)
		{
			songMissingStuff = [];

			swagShit.version ??= 0;
			fixSwagVersion(swagShit);
		}

		return swagShit;
	}

	static var songMissingStuff:Array<String> = [];

	public static function fixSwagVersion(swagShit:SwagSong)
	{
		switch (swagShit.version)
		{
			case 0:
				swagShit.gfVersion = dummySong.gfVersion;
				songMissingStuff.push('gfVersion');
			case 1:
				swagShit.stage = dummySong.stage;
				songMissingStuff.push('stage');
			case 2:
				swagShit.authors = 'Unknown';
				songMissingStuff.push('authors');
			case 3:
				swagShit.difficulty = NORMAL;
				songMissingStuff.push('difficulty');
			case 4:
				swagShit.generatedBy = '${Constants.SONG_GENERATED_BY_PREFIX}fixSwagVersion';
				songMissingStuff.push('generatedBy');
		}

		if (swagShit.version != SWAGVERSION)
		{
			if (swagShit.version < SWAGVERSION) swagShit.version += 1;
			if (swagShit.version > SWAGVERSION) swagShit.version -= 1;
			fixSwagVersion(swagShit);
		}
		else if (swagShit.version == SWAGVERSION)
		{
			// koya chart format
			// koyachartformat
			// koyta

			#if FIXSWAGVERSION_TRACES
			if (songMissingStuff.length > 0)
			{
				trace('Upgraded ${swagShit.song} to ${Constants.SONG_FORMAT}');
				for (thing in songMissingStuff)
					trace(' * Added $thing');
			}
			#end

			songMissingStuff = [];
		}
	}

	public static var SWAGVERSION:Int = 5;

	public static var dummySong:SwagSong =
		{
			song: 'Test',
			notes: [],
			bpm: 150,
			needsVoices: true,
			player1: 'bf',
			player2: 'dad',
			speed: 1,
			gfVersion: 'gf',
			stage: new MainStage(null, false).BG_NAME,
			authors: 'Kawai Sprite (ft. MtH)',
			difficulty: NORMAL,
			generatedBy: 'Macohi (hand)',
			version: SWAGVERSION
		}
}
