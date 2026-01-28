package backend;

import flixel.graphics.frames.FlxAtlasFrames;
using haxe.io.Path;

class AssetPaths
{
	public static var pixelZoom:Float = 6;

	public static var soundExt:String = #if web 'mp3' #else 'ogg' #end;

	public static function getPath(path:String, ?library:String):String
	{
		if (library != null)
			return getLibraryPath(path, library);

		return 'assets/$path';
	}

	public static function getLibraryPath(path:String, ?library:String):String
	{
		if (library == null)
			return getPath(path);

		return getPath('$library/$path');
	}

	public static function txt(path:String, ?library:String):String
		return getPath('$path.txt', library);

	public static function json(path:String, ?library:String):String
		return getPath('$path.json', library);

	public static function chart(song:String, chart:String, ?library:String):String
		return json('data/songs/${song.toLowerCase()}/$chart', library);

	public static function image(path:String, ?library:String):String
		return getPath('images/$path.png', library);

	public static function fromSparrow(path:String, ?library:String)
		return FlxAtlasFrames.fromSparrow(image(path, library), xml('images/$path', library));

	public static function sound(path:String, ?library:String):String
		return getPath('sounds/$path.$soundExt', library);

	public static function music(path:String, ?library:String):String
		return getPath('music/$path.$soundExt', library);

	public static function font(path:String, ?library:String)
		return getPath('fonts/$path', library);

	public static function xml(path:String, ?library:String):String
		return getPath('$path.xml', library);
}
