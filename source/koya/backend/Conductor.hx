package koya.backend;

import koya.backend.songs.Song.SwagSong;

/**
	Event for BPM change to new bpm
**/
typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor
{
	/** Current BPM **/
	public static var bpm:Float = 100;

	/** Beats in milliseconds **/
	public static var crochet:Float = ((60 / bpm) * 1000);

	/** Steps in milliseconds **/
	public static var stepCrochet:Float = crochet / 4;

	/** Current Song Position **/
	public static var songPosition:Float;

	/** Last Song Position **/
	public static var lastSongPos:Float;

	/** Song Position Offset **/
	public static var offset:Float = 0;

	/** Frames for the safe zone offset so `safeZoneOffset` can be calculated **/
	public static var safeFrames:Int = 10;

	/**  `safeFrames` in milliseconds **/
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

	/** A map of all the BPM change events **/
	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public function new() {}

	/** 
		Create a map of all BPM changes in `song`

		@param song The song you're maping the BPM changes for
	**/
	public static function mapBPMChanges(song:SwagSong)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length)
		{
			if (song.notes[i].changeBPM && song.notes[i].bpm != curBPM)
			{
				curBPM = song.notes[i].bpm;
				var event:BPMChangeEvent =
					{
						stepTime: totalSteps,
						songTime: totalPos,
						bpm: curBPM
					};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

	/**
		Change the BPM to `newBpm`

		@param newBpm new bpm
	**/
	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;

		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}
