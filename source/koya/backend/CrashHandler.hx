package koya.backend;

// crash handler stuff
import lime.app.Application;
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import openfl.Lib;
import haxe.io.Path;
import sys.io.File;
import sys.FileSystem;

using StringTools;
#end

class CrashHandler
{
	/**
		Prefix for the crash file
	**/
	public static final FILE_PREFIX:String = 'KoyaCrash_';

	/**
		Target place to report bugs
	**/
	public static final REPORT_PAGE:String = 'https://github.com/sphis-sinco/FunkinKoya/issues';

	/**
		File location for crash files
	**/
	public static final FILE_LOCATION:String = 'crash';

	/**
		The crash handler function that creates the log and displays the crash.

		Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
		Very cool person for real they don't get enough credit for their work
	**/
	#if CRASH_HANDLER
	public static function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String = './$FILE_LOCATION';
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		#if debug
		path += '-debug';
		#end

		path += '/$FILE_PREFIX$dateNow.txt';

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

		errMsg += "\nPlease report this error to the GitHub page: " + REPORT_PAGE;
		errMsg += "\n\n> Crash Handler written by: sqirra-rng, used by Psych Engine, and modified for Koya";

		if (!FileSystem.exists("./" + FILE_LOCATION)) FileSystem.createDirectory("./" + FILE_LOCATION);

		File.saveContent(path, errMsg + "\n");

		Sys.println('\n\nCRASH:\n');
		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		CoolUtil.alert("Error!", errMsg);
		Sys.exit(1);
	}
	#end
}
