package koya.backend;

import koya.backend.KoyaAssets;

using StringTools;

class AssetTextList
{
	public var text(get, never):String;

	function get_text():String
	{
		if (!KoyaAssets.exists(filepath)) return '';

		return KoyaAssets.getText(filepath);
	}

	public var textList(get, never):Array<String>;

	function get_textList():Array<String>
	{
		return CoolUtil.coolTextFile(filepath);
	}

	public var filepath:String = '';

	public function new(filepath:String, ?library:String)
	{
		this.filepath = AssetPaths.getPath(filepath, library);
		
		trace('Made AssetTextList($filepath)!');
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
}
