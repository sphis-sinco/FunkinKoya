package koya.backend;

import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static function coolTextFile(path:String):Array<String>
	{
		if (!Assets.exists(path))
		{
			trace('MISSING FILE: $path');
			return [];
		}

		var daList:Array<String> = Assets.getText(path).trim().split('\n');

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
}
