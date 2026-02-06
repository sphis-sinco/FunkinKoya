package koya.backend.songs;

class WeekList extends AssetTextList
{
	public function new()
	{
		super('data/weekList.txt', 'songs');
	}

	override function getEntryFilePath(entry:String):String
	{
		return AssetPaths.json('data/weeks/$entry', 'songs');
	}
}
