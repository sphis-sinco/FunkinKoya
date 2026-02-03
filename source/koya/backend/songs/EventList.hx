package koya.backend.songs;

class EventList extends AssetTextList
{
	public function new()
	{
		super(AssetPaths.txt('data/eventList', 'songs'));
	}

	override function getEntryFilePath(entry:String):String
	{
		return AssetPaths.json('data/events/$entry', 'songs');
	}
}
