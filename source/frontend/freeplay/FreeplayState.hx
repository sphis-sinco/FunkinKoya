package frontend.freeplay;

import backend.AssetPaths;
import backend.CoolUtil;

class FreeplayState extends MusicBeatState
{
	public var songList:Array<String> = [];

	override function create()
	{
		super.create();

		songList = CoolUtil.coolTextFile(AssetPaths.txt('data/freeplaySonglist'));
		trace(songList);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
