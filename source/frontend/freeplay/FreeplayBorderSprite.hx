package frontend.freeplay;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

class FreeplayBorderSprite extends FlxTypedGroup<FlxSprite>
{
	public static final COLOR_INNER = FlxColor.fromString('#201E27');
	public static final COLOR_OUTER = FlxColor.fromString('#232234');

	public static final INNER_PADDING = 20;

	public var innerSprite:FlxSprite;
	public var outerSprite:FlxSprite;

	override public function new(width:Int, height:Int, ?x:Float, ?y:Float)
	{
		super();

		innerSprite = new FlxSprite(x + (INNER_PADDING / 2), y + (INNER_PADDING / 2)).makeGraphic(width - INNER_PADDING, height - INNER_PADDING, COLOR_INNER);
		outerSprite = new FlxSprite(x, y).makeGraphic(width, height, COLOR_OUTER);

		add(outerSprite);
		add(innerSprite);
	}
}

enum FreeplayBorderSpriteTypes
{
	INNER;
	OUTER;
}
