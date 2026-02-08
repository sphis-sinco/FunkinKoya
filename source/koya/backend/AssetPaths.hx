package koya.backend;

import koya.backend.modding.ModCore;
import koya.backend.KoyaAssets;
import animate.FlxAnimateFrames;
import flixel.graphics.frames.FlxAtlasFrames;

using haxe.io.Path;
using StringTools;

class AssetPaths
{
	/** Sound extension **/
	public static var soundExt:String = #if web 'mp3' #else 'ogg' #end;

	/** Will disable the mod check stuff for one use of `getPath` **/
	public static var tempDisableModCheck:Bool = false;

	/**
		Get asset or mod path

		@param path filepath
		@param library library
	**/
	public static function getPath(path:String, ?library:String):String
	{
		if (library != null) return getLibraryPath(path, library);

		#if MOD_SUPPORT
		if (!tempDisableModCheck) for (mod in ModCore.enabledMods)
		{
			var modPath:String = '${ModCore.MOD_DIRECTORY}/$mod/$path';

			// First come first serve
			if (KoyaAssets.exists(modPath)) return modPath;
		}
		#end

		tempDisableModCheck = false;
		return 'assets/$path';
	}

	/** 
		Get all mod paths from base: `path`

		@param path filepath
		@param library library
	**/
	public static function getAllModPaths(path:String, ?library:String):Array<String>
	{
		var modPaths:Array<String> = [];

		#if MOD_SUPPORT
		for (mod in ModCore.enabledMods)
		{
			var modPath:String = '${ModCore.MOD_DIRECTORY}/$mod/${path.replace('assets/', '')}';
			trace(modPath);

			if (KoyaAssets.exists(modPath)) modPaths.push(modPath);
		}
		#end

		return modPaths;
	}

	/** 
		Get `path` using library folders 

		@param path filepath
		@param library library
	**/
	public static function getLibraryPath(path:String, ?library:String):String
	{
		var targetFuckingLibrary = library;

		if (targetFuckingLibrary == null) targetFuckingLibrary = 'main';

		return getPath('${targetFuckingLibrary.length > 0 ? '$targetFuckingLibrary/' : ''}$path');
	}

	/** Get `.frag` file using `getPath` **/
	public static function frag(path:String, ?library:String):String
		return getPath('shaders/$path.frag', library);

	/** Get `.txt` file using `getPath` **/
	public static function txt(path:String, ?library:String):String
		return getPath('$path.txt', library);

	/** Get `.json` file using `getPath` **/
	public static function json(path:String, ?library:String):String
		return getPath('$path.json', library);

	/**
		Get chart file using `json`

		@param song Song folder
		@param chart Song chart file
	**/
	public static function chart(song:String, chart:String, ?library:String):String
		return json('data/songs/${song.toLowerCase()}/$chart', library ?? 'songs');

	/** Get `.png` file using `getPath` **/
	public static function image(path:String, ?library:String):String
		return getPath('images/$path.png', library);

	/** Get `FlxAtlasFrames` via `fromSparrow` **/
	public static function fromSparrow(path:String, ?library:String)
		return FlxAtlasFrames.fromSparrow(image(path, library), xml('images/$path', library));

	/** Get sound file using `getPath` **/
	public static function sound(path:String, ?library:String):String
		return getPath('sounds/$path.$soundExt', library);

	/** Get music file using `getPath` **/
	public static function music(path:String, ?library:String):String
		return getPath('music/$path.$soundExt', library);

	/**
		Get song instrumental using `getPath`

		@param song Song folder
	**/
	public static function song_inst(song:String, ?library:String):String
		return music('songs/$song/Inst', library ?? 'songs');

	/**
		Get song voices file using `getPath`

		@param song Song folder
	**/
	public static function song_voices(song:String, ?library:String):String
		return music('songs/$song/Voices', library ?? 'songs');

	/** Get font file using `getPath` **/
	public static function font(path:String, ?library:String)
		return getPath('fonts/$path', library);

	/** Get `.xml` file using `getPath` **/
	public static function xml(path:String, ?library:String):String
		return getPath('$path.xml', library);

	/** Get animateAtlas path via `getPath` **/
	public static function animateAtlas(path:String, ?library:String):String
		return getPath('images/$path', library);

	/** 
		Get `FlxAnimateFrames` using `animateAtlas`

		@param key animateAtlas `path`
	**/
	public static function getAnimateAtlas(key:String, ?library:String):FlxAnimateFrames
	{
		var graphicKey:String = animateAtlas(key, library);

		if (!KoyaAssets.exists('${graphicKey}/Animation.json')) throw 'No Animation.json file exists at the specified path (${graphicKey})';

		return FlxAnimateFrames.fromAnimate(graphicKey);
	}
}
