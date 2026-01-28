package backend;

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
		return ' : Week 1 Update';
	}

	public static var WINDOW_TITLE(get, never):String;

	static function get_WINDOW_TITLE():String
	{
		return 'Funkin\' Koya' + #if debug '*' #else '' #end;
	}
}
