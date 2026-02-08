package;

import koya.backend.CrashHandler;
import koya.frontend.ui.Watermark;
import koya.backend.InitState;
import flixel.FlxGame;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite
{
	/**
		The target framerate
	**/
	public static var FPS:Int = 144;

	/**
		Watermark object.

		Public static to allow editing from other classes.
	**/
	public static var WATERMARK:Watermark;

	/**
		Adds the FlxGame
		Adds the watermark
		and initalizes the crash handler
	**/
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, InitState, FPS, FPS, false));

		WATERMARK = new Watermark(2);
		#if !mobile
		addChild(WATERMARK);
		#end

		#if CRASH_HANDLER
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR, CrashHandler.onCrash);
		#end
	}
}
