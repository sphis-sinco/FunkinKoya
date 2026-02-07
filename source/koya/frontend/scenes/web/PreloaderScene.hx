package koya.frontend.scenes.web;

import koya.backend.AssetPaths;
import flixel.util.FlxColor;
import koya.backend.Constants;
import flixel.system.FlxAssets;
import flixel.system.FlxBasePreloader;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.FlxG;

class PreloaderScene extends FlxBasePreloader
{
	var _buffer:Sprite;

	var _text:TextField;
	var _bmpBar:Bitmap;

	override public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>):Void
	{
		super(MinDisplayTime, AllowedURLs);
	}

	var color_bg:FlxColor = 0x2e4324;
	var color_bar:FlxColor = 0xff54bb;
	var color_text:FlxColor = 0x95e76f;
	var color_overlay:FlxColor = 0xff85cc;

	override function create()
	{
		super.create();

		_buffer = new Sprite();
		_buffer.scaleX = _buffer.scaleY = 2;
		addChild(_buffer);
		_width = Std.int(Lib.current.stage.stageWidth / _buffer.scaleX);
		_height = Std.int(Lib.current.stage.stageHeight / _buffer.scaleY);
		_buffer.addChild(new Bitmap(new BitmapData(_width, _height, false, color_bg)));

		_bmpBar = new Bitmap(new BitmapData(1, 7, false, color_bar));
		_bmpBar.x = 4;
		_bmpBar.y = _height - 11;
		_buffer.addChild(_bmpBar);

		_text = new TextField();
		_text.defaultTextFormat = new TextFormat(#if web FlxAssets.FONT_DEFAULT #else AssetPaths.font('vcr.ttf') #end, 8, color_text);
		_text.embedFonts = true;
		_text.selectable = false;
		_text.multiline = false;
		_text.x = 2;
		_text.y = _bmpBar.y - 24;
		_text.width = _text.defaultTextFormat.size * ((FlxG.width - (_text.x * 2)) / _text.defaultTextFormat.size);
		_buffer.addChild(_text);

		var bitmap = new Bitmap(new BitmapData(_width, _height, false, color_overlay));
		var i:Int = 0;
		var j:Int = 0;
		while (i < _height)
		{
			j = 0;
			while (j < _width)
			{
				bitmap.bitmapData.setPixel(j++, i, 0);
			}
			i += 2;
		}
		bitmap.blendMode = BlendMode.OVERLAY;
		bitmap.alpha = 0.25;
		_buffer.addChild(bitmap);
	}

	override function update(Percent:Float)
	{
		super.update(Percent);

		_bmpBar.scaleX = Percent * (_width - 8);
		_text.text = 'Koya ${Constants.VERSION}\n${flixel.math.FlxMath.roundDecimal(Percent * 100, 2)}%';
	}

	override function destroy():Void
	{
		if (_buffer != null) removeChild(_buffer);

		_buffer = null;
		_bmpBar = null;
		_text = null;

		super.destroy();
	}
}
