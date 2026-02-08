package koya.backend;

import lime.app.Application;
import koya.backend.KoyaAssets;

using StringTools;

class CoolUtil
{
	/**
		Splits a text file of path: `path`,
		if it exists into an array split by new line characters,

		otherwise it will just return a blank array

		@param path text file path
	**/
	public static function splitTextFile(path:String):Array<String>
	{
		if (!KoyaAssets.exists(path))
		{
			trace('MISSING FILE: $path');
			return [];
		}

		var daList:Array<String> = KoyaAssets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	/**
	 * Constrain an float between a minimum and maximum value.
	 */
	public static function clampFloat(value:Float, min:Float, max:Float):Float
	{
		return value < min ? min : value > max ? max : value;
	}

	/**
	 * Constrain an integer between a minimum and maximum value.
	 */
	public static function clampInt(value:Int, min:Int, max:Int):Int
	{
		// Don't use Math.min because it returns a Float.
		return value < min ? min : value > max ? max : value;
	}

	/**
		Display an alert

		@param title alert title
		@param msg alert message
	**/
	public static function alert(title:String, msg:String)
		Application.current.window.alert(msg, title);
}
