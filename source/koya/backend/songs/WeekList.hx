package koya.backend.songs;

class WeekList extends AssetTextList
{
	public function new()
	{
		super(AssetPaths.txt('data/weekList', 'songs'));
	}

	override function getEntryFilePath(entry:String):String
	{
		return AssetPaths.json('data/weeks/$entry', 'songs');
	}
}
