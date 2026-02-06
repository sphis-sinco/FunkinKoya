package koya.backend;

import koya.backend.KoyaAssets;

class KoyaAssets
{
	public static function exists(path:String):Bool
	{
		#if sys
		return sys.FileSystem.exists(path);
		#end

		return Assets.exists(path);
	}

	public static function getText(path:String):String
	{
		#if sys
		return sys.io.File.getContent(path);
		#end

		return Assets.getText(path);
	}
}
