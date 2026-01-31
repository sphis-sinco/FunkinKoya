package frontend.play.songs;

class SongClass
{
	public static function getSongClass(song:String):SongClass
		return SongClassGetter.getSongClass(song);

	public function new() {}

	public function preCountdown():Bool { return true; }
	public function postCreate() {}
	public function countdownTick(tick:Int) {}

	public function startSong() {}
	public function generateSong(dataPath:String) {}
	public function generateStaticArrows(player:Bool, index:Int, arrow:StaticNote) {}

	public function pause() {}
	public function unpause() {}
	public function resyncVocals() {}
	public function keyShit() {}

	public function update(elapsed:Float) {}

	public function endSong():Bool { return true; }

	public function popUpScore(strumtime:Float) {}

	public function noteMiss(direction:Int) {}
	public function goodNoteHit(note:Note) {}

	public function stepHit(step:Int) {}
	public function beatHit(beat:Int) {}
	public function sectionHit(section:Int) {}

	public function moveCamera(bf:Bool):Bool { return true; }
}
