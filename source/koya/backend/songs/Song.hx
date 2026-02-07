package koya.backend.songs;

import koya.backend.play.Difficulty;
import koya.frontend.scenes.play.stages.basegame.*;
import koya.backend.AssetPaths;
import haxe.Json;
import haxe.format.JsonParser;
import koya.backend.KoyaAssets;

using StringTools;

/** Saved Chart File **/
typedef ChartSwagSong =
{
	var song:SwagSong;
}

/** Song Data **/
typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;

	var ?gfVersion:String;
	var ?stage:String;
	var ?authors:String;
	var ?difficulty:Difficulty;
	var ?generatedBy:String;

	var ?version:Null<Int>;
}

class Song
{
	/**
		Loads a song's JSON file and returns it
		using `parseJSONshit`

		@param jsonInput song chart file
		@param folder song folder
		@param fix This determines if `parseJSONshit` will upgrade the JSON to the latest chart format
	**/
	public static function loadFromJson(jsonInput:String, folder:String, fix:Bool = true):SwagSong
	{
		var rawJson:String = '';
		try
		{
			rawJson = KoyaAssets.getText(AssetPaths.chart(folder, jsonInput)).trim();
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

	/**
		Receives a Chart JSON and will send back the Song Chart JSON
		with the optional ability of upgrading it to the latest chart format

		@param rawJson song chart file
		@param fix This determines the function will upgrade the JSON to the latest chart format
	**/
	public static function parseJSONshit(rawJson:ChartSwagSong, fix:Bool = true):SwagSong
	{
		if (rawJson == null) return null;

		var swagShit:SwagSong = rawJson.song;

		if (fix)
		{
			addedStuff = [];

			swagShit.version ??= 0;
			fixSwagVersion(swagShit);
		}

		return swagShit;
	}

	/** Used in `fixSwagVersion` to see whats been added **/
	static var addedStuff:Array<String> = [];

	/** Used in `fixSwagVersion` to see whats been removed **/
	static var removedStuff:Array<String> = [];

	/**
		Upgrades `swagShit` to the latest shit B)

		@param swagShit song JSON
	**/
	public static function fixSwagVersion(swagShit:SwagSong)
	{
		switch (swagShit.version)
		{
			case 0:
				swagShit.gfVersion = dummySong.gfVersion;
				addedStuff.push('gfVersion');
			case 1:
				swagShit.stage = dummySong.stage;
				addedStuff.push('stage');
			case 2:
				swagShit.authors = 'Unknown';
				addedStuff.push('authors');
			case 3:
				swagShit.difficulty = NORMAL;
				addedStuff.push('difficulty');
			case 4:
				swagShit.generatedBy = '${Constants.SONG_GENERATED_BY_PREFIX}fixSwagVersion';
				addedStuff.push('generatedBy');
			case 5:
				var n = 0;
				for (section in swagShit.notes)
					for (note in section.sectionNotes)
						if (note[3] == null)
						{
							note[3] = '';
							n++;
						}
				addedStuff.push('$n (blank) event notes');
			case 6:
				var t = 0;
				for (section in swagShit.notes)
				{
					Reflect.deleteField(section, 'typeOfSection');
					t++;
				}
				removedStuff.push('$t unused typeOfSection fields');
			case 7:
				var e = 0;
				for (section in swagShit.notes)
				{
					if (section.sectionEvents == null)
					{
						section.sectionEvents = [];
						e++;
					}
				}
				addedStuff.push('$e blank sectionEvent\'s');
		}

		if (swagShit.version != SWAGVERSION)
		{
			if (swagShit.version < SWAGVERSION) swagShit.version += 1;
			if (swagShit.version > SWAGVERSION) swagShit.version -= 1;
			fixSwagVersion(swagShit);
		}
		else if (swagShit.version == SWAGVERSION)
		{
			#if FIXSWAGVERSION_TRACES
			trace('Upgraded ${swagShit.song} to ${Constants.SONG_FORMAT}');
			if (addedStuff.length > 0) for (thing in addedStuff)
				trace(' * Added $thing');
			if (removedStuff.length > 0) for (thing in removedStuff)
				trace(' * Removed $thing');
			#end

			addedStuff = [];
			removedStuff = [];
		}
	}

	/** Chart Format Version **/
	public static var SWAGVERSION:Int = 8;

	/** Dummy Song : Test **/
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
