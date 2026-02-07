package koya.backend;

import flixel.FlxG;
import koya.backend.KoyaAssets;

using StringTools;

class AssetTextList
{
	/** The text of the file with appends from mods **/
	public var text(get, never):String;

	function get_text():String
	{
		if (!KoyaAssets.exists(filepath)) return '';

		var txt = KoyaAssets.getText(filepath);

		for (append in getAppends())
			txt += '\n' + KoyaAssets.getText(append);

		return txt;
	}

	/** The text of the file with appends from mods split by newlines **/
	public var textList(get, never):Array<String>;

	function get_textList():Array<String>
	{
		var txts:Array<String> = text.split('\n');
		return txts;
	}

	/** Filepath to the asset **/
	public var filepath:String = '';

	/** Initalize the AssetTextList **/
	public function new(filepath:String)
	{
		this.filepath = filepath;
		trace('Made AssetTextList($filepath)!');

		FlxG.log.add(text);
		FlxG.log.add(textList);
	}

	/** 
		Checks if `text` has `entry` or if `textList` does.

		@param entry text or value to check for
	**/
	public function has(entry:String):Bool
	{
		return textList.contains(entry) || text.contains(entry);
	}

	/**
		Gets a file based on a `textList` entry

		@param entryID number of the entry
	**/
	public function getEntryFile(entryID:Int):String
	{
		return getEntryFilePath(textList[entryID]);
	}

	/**
		Returns the file `getEntryFile` desires with the prefix

		@param entry Filename for the path
	**/
	public function getEntryFilePath(entry:String):String
	{
		return '$entry';
	}

	/** Get all the mod append files for `filepath` **/
	public function getAppends():Array<String>
	{
		var paths = AssetPaths.getAllModPaths(filepath.replace('assets/', '_append/'));

		// trace(paths);

		return paths;
	}
}
