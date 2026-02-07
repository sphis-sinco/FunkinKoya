package koya.backend;

import flixel.FlxG;
import koya.backend.KoyaAssets;

using StringTools;

class AssetTextList
{
	public var text(get, never):String;

	function get_text():String
	{
		if (!KoyaAssets.exists(filepath)) return '';

		var txt = KoyaAssets.getText(filepath);

		for (append in getAppends())
			txt += '\n' + KoyaAssets.getText(append);

		return txt;
	}

	public var textList(get, never):Array<String>;

	function get_textList():Array<String>
	{
		var txts:Array<String> = CoolUtil.coolTextFile(filepath);

		for (append in getAppends())
			for (v in CoolUtil.coolTextFile(append))
				txts.push(v);

		return txts;
	}

	public var filepath:String = '';

	public function new(filepath:String)
	{
		this.filepath = filepath;
		trace('Made AssetTextList($filepath)!');

		FlxG.log.add(text);
		FlxG.log.add(textList);
	}

	public function has(entry:String):Bool
	{
		return textList.contains(entry) || text.contains(entry);
	}

	public function getEntryFile(entryID:Int):String
	{
		return getEntryFilePath(textList[entryID]);
	}

	public function getEntryFilePath(entry:String):String
	{
		return '';
	}

	public function getAppends():Array<String>
	{
		var paths = AssetPaths.getAllModPaths(filepath.replace('assets/', '_append/'));

		// trace(paths);

		return paths;
	}
}
