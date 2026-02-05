package;

import koya.backend.CrashHandler;
import koya.frontend.ui.Watermark;
import lime.app.Application;
import koya.backend.InitState;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

using StringTools;

class Main extends Sprite
{
	public static var FPS:Int = 144;

	public static var WATERMARK:Watermark;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, InitState, FPS, FPS));

		WATERMARK = new Watermark(2);
		#if !mobile
		addChild(WATERMARK);
		#end

		#if CRASH_HANDLER
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR, CrashHandler.onCrash);
		#end
	}
}
