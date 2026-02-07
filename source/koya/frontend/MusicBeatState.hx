package koya.frontend;

import koya.backend.plugins.Cursor;
import koya.backend.Conductor;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import koya.backend.controls.Controls;
import koya.backend.controls.PlayerSettings;

class MusicBeatState extends FlxUIState
{
	public var lastBeat:Float = 0;
	public var lastStep:Float = 0;

	public var curStep:Int = 0;
	public var curBeat:Int = 0;

	public var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override function create()
	{
		if (transIn != null) trace('reg ' + transIn.region);

		super.create();

		
		Cursor.cursorVisible = false;
		sectionHit();
		controls.setKeyboardScheme(Custom);
	}

	override function update(elapsed:Float)
	{
		// everyStep();
		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();
		updateSection();

		if (oldStep != curStep && curStep > 0) stepHit();

		super.update(elapsed);
	}

	public function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	public var curSection:Int = 0;

	public function updateSection()
	{
		curSection = Math.floor(curStep / 16);
	}

	public function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent =
			{
				stepTime: 0,
				songTime: 0,
				bpm: 0
			}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime) lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0) beatHit();
		if (curStep % 16 == 0) sectionHit();
	}

	public function beatHit():Void {}

	public function sectionHit():Void {}
}
