package koya.backend;

import koya.backend.songs.Song;
#if INCLUDE_GIT
import koya.backend.macros.Git;
#end
import koya.frontend.ui.ArrowUI;
import koya.frontend.freeplay.FreeplayBorderSprite;
import flixel.util.FlxColor;
import lime.app.Application;

class Constants
{
	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		return Application.current.meta.get('version') + VERSION_SUFFIX;
	}

	public static var VERSION_SUFFIX(get, never):String;

	static function get_VERSION_SUFFIX():String
	{
		#if EMPTY_VERSION_SUFFIX
		return '';
		#end

		var suffix:String = '';

		#if INCLUDE_GIT
		suffix += ' (${Git.branch()}:${Git.hash()})';
		#end

		return suffix;
	}

	public static var WINDOW_TITLE(get, never):String;

	static function get_WINDOW_TITLE():String
	{
		return 'Funkin\' Koya' + #if (DEBUG_ASTERISK) '*' #else '' #end;
	}

	public static var FREEPLAY_BORDER_COLOR_INNER(get, never):Null<FlxColor>;

	static function get_FREEPLAY_BORDER_COLOR_INNER():Null<FlxColor>
		return FreeplayBorderSprite.COLOR_INNER;

	public static var FREEPLAY_BORDER_COLOR_OUTER(get, never):Null<FlxColor>;

	static function get_FREEPLAY_BORDER_COLOR_OUTER():Null<FlxColor>
		return FreeplayBorderSprite.COLOR_OUTER;

	public static var FREEPLAY_BORDER_INNER_PADDING(get, never):Int;

	static function get_FREEPLAY_BORDER_INNER_PADDING():Int
		return FreeplayBorderSprite.INNER_PADDING;

	public static var UI_ARROW_SKIN_DEFAULT(get, never):ArrowUISkinData;

	static function get_UI_ARROW_SKIN_DEFAULT():ArrowUISkinData
		return ArrowUI.SKIN_DEFAULT;

	public static var UI_ARROW_SKIN_DIFFICULTY_SELECT(get, never):ArrowUISkinData;

	static function get_UI_ARROW_SKIN_DIFFICULTY_SELECT():ArrowUISkinData
		return ArrowUI.SKIN_DIFFICULTY_SELECT;

	public static var SONG_GENERATED_BY_PREFIX(get, never):String;

	static function get_SONG_GENERATED_BY_PREFIX():String
	{
		return '${Constants.WINDOW_TITLE} ${Constants.VERSION} | ';
	}

	public static var SONG_FORMAT(get, never):String;

	static function get_SONG_FORMAT():String
	{
		return getSongFormatFromVersion(Song.SWAGVERSION);
	}

	public static function getSongFormatFromVersion(version:Int)
	{
		return 'koyta_$version';
	}
}
