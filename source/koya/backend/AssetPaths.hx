package koya.backend;

import koya.backend.modding.ModCore;
import koya.backend.KoyaAssets;
import animate.FlxAnimateFrames;
import flixel.graphics.frames.FlxAtlasFrames;

using haxe.io.Path;

class AssetPaths
{
	public static var pixelZoom:Float = 6;

	public static var soundExt:String = #if web 'mp3' #else 'ogg' #end;

	public static function getPath(path:String, ?library:String):String
	{
		if (library != null) return getLibraryPath(path, library);

		#if MOD_SUPPORT
		for (mod in ModCore.enabledMods)
		{
			var modPath:String = 'mods/$mod/$path';

			// First come first serve
			if (KoyaAssets.exists(modPath)) return modPath;
		}
		#end

		return 'assets/$path';
	}

	public static function getLibraryPath(path:String, ?library:String):String
	{
		if (library == null) return getPath(path);

		return getPath('$library/$path');
	}

	public static function frag(path:String, ?library:String):String
		return getPath('shaders/$path.frag', library);

	public static function txt(path:String, ?library:String):String
		return getPath('$path.txt', library);

	public static function json(path:String, ?library:String):String
		return getPath('$path.json', library);

	public static function chart(song:String, chart:String, ?library:String):String
		return json('data/songs/${song.toLowerCase()}/$chart', library ?? 'songs');

	public static function image(path:String, ?library:String):String
		return getPath('images/$path.png', library);

	public static function fromSparrow(path:String, ?library:String)
		return FlxAtlasFrames.fromSparrow(image(path, library), xml('images/$path', library));

	public static function sound(path:String, ?library:String):String
		return getPath('sounds/$path.$soundExt', library);

	public static function music(path:String, ?library:String):String
		return getPath('music/$path.$soundExt', library);

	public static function song_inst(song:String, ?library:String):String
		return music('songs/$song/Inst', library ?? 'songs');

	public static function song_voices(song:String, ?library:String):String
		return music('songs/$song/Voices', library ?? 'songs');

	public static function font(path:String, ?library:String)
		return getPath('fonts/$path', library);

	public static function xml(path:String, ?library:String):String
		return getPath('$path.xml', library);

	public static function animateAtlas(path:String, ?library:String):String
		return getPath('images/$path', library);

	public static function getAnimateAtlas(key:String, ?library:String):FlxAnimateFrames
	{
		var graphicKey:String = animateAtlas(key, library);

		if (!KoyaAssets.exists('${graphicKey}/Animation.json')) throw 'No Animation.json file exists at the specified path (${graphicKey})';

		return FlxAnimateFrames.fromAnimate(graphicKey);
	}
}
