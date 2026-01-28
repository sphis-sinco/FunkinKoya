package backend;

import lime.app.Application;

class Constants
{
	public static var VERSION(get, never):String;

	static function get_VERSION():String
	{
		return Application.current.meta.get('version');
	}

	public static var WINDOW_TITLE(get, never):String;

	static function get_WINDOW_TITLE():String
	{
		return Application.current.meta.get('title') + #if debug '*' #else '' #end;
	}
}
