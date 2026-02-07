package koya.backend.songs;

/** Section Data **/
typedef SwagSection =
{
	var sectionEvents:Array<Dynamic>;
	var sectionNotes:Array<Dynamic>;

	var lengthInSteps:Int;
	var mustHitSection:Bool;
	var bpm:Float;
	var changeBPM:Bool;
	var altAnim:Bool;
}
