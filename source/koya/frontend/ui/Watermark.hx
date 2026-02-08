package koya.frontend.ui;

import koya.backend.save.Save;
import flixel.system.FlxAssets;
import flixel.FlxG;
import koya.backend.Constants;
import koya.backend.AssetPaths;
import openfl.text.TextFormat;
import openfl.display.FPS;

class Watermark extends FPS
{
	override public function new(x:Float = 10, y:Float = 2)
	{
		super(x, y, 0xFFFFFF);

		defaultTextFormat = new TextFormat(#if web FlxAssets.FONT_DEFAULT #else AssetPaths.font('vcr.ttf') #end, 16, 0xFFFFFF);
		width = defaultTextFormat.size * ((FlxG.width - (x * 2)) / defaultTextFormat.size);
	}

	override function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);

		if (currentCount != cacheCount /*&& visible*/)
		{
			var newText = '';

			if (Save?.preferences?.get()?.fpsCounter ?? true) newText += 'FPS: $currentFPS\n';
			newText += 'Koya ${Constants.VERSION}\n';

			#if CONTEXT3DSTATS
			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			newText += '\ntotalDC: ${Context3DStats.totalDrawCalls()}';
			newText += '\nstageDC: ${Context3DStats.contextDrawCalls(DrawCallContext.STAGE)}';
			newText += '\nstage3DDC: ${Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D)}';
			#end
			#end

			if (newText != lastText)
			{
				text = newText;
				lastText = newText;
			}
		}

		cacheCount = currentCount;
	}
}
