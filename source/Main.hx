package;

import koya.frontend.ui.Watermark;
import lime.app.Application;
import koya.backend.InitState;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
// crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import openfl.Lib;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

class Main extends Sprite
{
	public static var FPS:Int = 144;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, InitState, FPS, FPS));

		#if !mobile
		addChild(new Watermark(2));
		#end

		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String = './crash';
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		#if debug
		path += '-debug';
		#end

		path += '/KoyaCrash_$dateNow.txt';

		errMsg += "Uncaught Error: " + e.error + "\n\n";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + ":" + line + " \n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nPlease report this error to the GitHub page: https://github.com/sphis-sinco/FunkinKoya/issues";
		errMsg += "\n\n> Crash Handler written by: sqirra-rng, used by Psych Engine, and modified for Koya";

		if (!FileSystem.exists("./crash/")) FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println('\n\nCRASH:\n');
		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		Sys.exit(1);
	}
	#end
}
