package frontend.freeplay;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import backend.AssetPaths;
import flixel.addons.display.FlxGridOverlay;
import backend.CoolUtil;

class FreeplayState extends MusicBeatState
{
	public var songList:Array<String> = [];

	public var songText:FlxTypedGroup<Alphabet>;

	override function create()
	{
		super.create();

		songList = CoolUtil.coolTextFile(AssetPaths.txt('data/freeplaySonglist'));
		trace(songList);

		var GRID_SIZE = 32;
		var gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * Std.int(FlxG.width / GRID_SIZE) + 2,
			GRID_SIZE * Std.int(FlxG.height / GRID_SIZE) + 2);
		add(gridBG);

		songText = new FlxTypedGroup<Alphabet>();
		add(songText);

		var i = 0;
		for (song in songList)
		{
			var songAlphabet:Alphabet = new Alphabet(24, 24 + (i * 64), song.toLowerCase(), true);
			songAlphabet.ID = i;
			songText.add(songAlphabet);

			i++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
