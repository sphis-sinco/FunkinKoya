package koya.frontend.play;

import koya.backend.songs.Song.SwagSong;
import koya.backend.Conductor;
import koya.backend.AssetPaths;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;

using StringTools;

class Note extends FunkinSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteID:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var noteData:String = '';
	public var inactive:Bool = false;

	public function new(strumTime:Float, noteID:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?eventShit:String = '')
	{
		this.noteID = noteID;
		this.noteData = eventShit;
		super(50 + (swagWidth * this.noteID), -2000);

		if (prevNote == null) prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		this.strumTime = strumTime;

		initVisuals();
	}

	public function initVisuals()
	{
		initAsset();
		noteAnims();
	}

	public function initAsset()
	{
		var event:String = '';

		if (noteData != null) event = noteData;

		switch (event.toLowerCase().trim())
		{
			default:
				// trace('no case for ${event.toLowerCase().trim()}');
				initAssetOG();
		}
	}

	public function noteAnims()
	{
		var event:String = '';

		if (noteData != null) event = noteData;

		switch (event.toLowerCase().trim())
		{
			default:
				// trace('no case for ${event.toLowerCase().trim()}');
				ogNoteAnims();
		}
	}

	public function ogNoteAnims()
	{
		switch (noteID)
		{
			case 0:
				playAnim('purpleScroll');
			case 1:
				playAnim('blueScroll');
			case 2:
				playAnim('greenScroll');
			case 3:
				playAnim('redScroll');
		}

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 1.8;

			switch (noteID)
			{
				case 2:
					playAnim('greenholdend');
				case 3:
					playAnim('redholdend');
				case 1:
					playAnim('blueholdend');
				case 0:
					playAnim('purpleholdend');
			}

			updateHitbox();
			// x -= width / 2;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteID)
				{
					case 0:
						prevNote.playAnim('purplehold');
					case 1:
						prevNote.playAnim('bluehold');
					case 2:
						prevNote.playAnim('greenhold');
					case 3:
						prevNote.playAnim('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		this.visible = !inactive;

		if (mustPress)
		{
			// The * 0.5 us so that its easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5)) canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset) tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition) wasGoodHit = true;
		}

		if (tooLate) if (alpha > 0.3) alpha = 0.3;
	}

	public function getDirectionName():String
	{
		return switch (Math.abs(noteID % 4))
		{
			case 0: 'LEFT';
			case 1: 'DOWN';
			case 2: 'UP';
			case 3: 'RIGHT';

			case _:
				trace('UNKNOWN_DIR=$noteID');
				'UNKNOWN_DIR=$noteID';
		}
	}

	public function initAssetOG()
	{
		frames = AssetPaths.fromSparrow('NOTE_assets');

		animation.addByPrefix('greenScroll', 'green0');
		animation.addByPrefix('redScroll', 'red0');
		animation.addByPrefix('blueScroll', 'blue0');
		animation.addByPrefix('purpleScroll', 'purple0');

		animation.addByPrefix('purpleholdend', 'pruple end hold');
		animation.addByPrefix('greenholdend', 'green hold end');
		animation.addByPrefix('redholdend', 'red hold end');
		animation.addByPrefix('blueholdend', 'blue hold end');

		animation.addByPrefix('purplehold', 'purple hold piece');
		animation.addByPrefix('greenhold', 'green hold piece');
		animation.addByPrefix('redhold', 'red hold piece');
		animation.addByPrefix('bluehold', 'blue hold piece');

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();
	}

	public static function getIfNoteIsInactive(note:Note, ?song:SwagSong):Bool
	{
		var event:String = '';

		if (note != null) if (note.noteData != null) event = note.noteData;

		switch (event.toLowerCase().trim()) {}

		return false;
	}

	public static function getAlt(note:Note, ?song:SwagSong):String
	{
		var event:String = '';

		if (note != null) if (note.noteData != null) event = note.noteData;

		switch (event.toLowerCase().trim())
		{
			case 'alt', 'alternate':
				return '-alt';
			case 'cheer':
				return '-cheer';
			case 'hey':
				return '-hey';

			default:
				if (event.toLowerCase().trim().length > 0) trace('No case for: "${event.toLowerCase().trim()}"');
		}

		return '';
	}

	public static function getSingAnimation(note:Note, ?song:SwagSong, ?miss:Bool = false, ?addition:String):String
	{
		var animationName:String = 'sing${note.getDirectionName().toUpperCase()}';
		var event:String = '';

		if (note != null) if (note.noteData != null) event = note.noteData;

		switch (event.toLowerCase().trim())
		{
			case 'cheer':
				animationName = 'cheer';
				addition = null;
			case 'hey':
				animationName = 'hey';
				addition = null;

			default:
				if (event.toLowerCase().trim().length > 0) trace('No case for: "${event.toLowerCase().trim()}"');
		}

		if (miss) animationName += 'miss';
		return (animationName + ((addition != null) ? addition : ''));
	}
}
