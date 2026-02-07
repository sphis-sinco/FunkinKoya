package koya.backend;

import lime.utils.Assets;

class KoyaAssets
{
	/**
		Use lime or sys to check if
		`path` exists

		@param path File to look for
	**/
	public static function exists(path:String):Bool
	{
		#if sys
		return sys.FileSystem.exists(path);
		#end

		return Assets.exists(path);
	}

	/**
		Use lime or sys to receive the
		text content from `path`

		@param path File to get the text from
	**/
	public static function getText(path:String):String
	{
		#if sys
		return sys.io.File.getContent(path);
		#end

		return Assets.getText(path);
	}


	/**
		Use sys to read `directory` and return the contents

		@param directory Directory
	**/
	public static function readDirectory(directory:String):Array<String>
	{
		#if sys
		return sys.FileSystem.readDirectory(directory);
		#end

		trace('Unsupported');
		return [];
	}
}
