package koya.frontend.ui;

import koya.backend.AssetPaths;
import flixel.FlxSprite;

class ArrowUI extends FlxSprite
{
	public static var SKIN_DIFFICULTY_SELECT:ArrowUISkinData =
		{
			animation_suffix: ' difficulty select',
			path: 'ui_arrows-difficulty-select'
		};
	public static var SKIN_DEFAULT:ArrowUISkinData =
		{
			animation_suffix: '',
			path: 'ui_arrows'
		};

	override public function new(direction:ArrowUIDirection, ?skin:ArrowUISkinData, ?x:Float, ?y:Float)
	{
		super(x, y);

		var skindata:ArrowUISkinData = skin ?? SKIN_DEFAULT;

		frames = AssetPaths.fromSparrow(skindata.path, 'ui');
		animation.addByPrefix('arrow', direction + skindata.animation_suffix, 24);
		animation.play('arrow');

		updateHitbox();
	}
}

typedef ArrowUISkinData =
{
	path:String,
	animation_suffix:String,
}

enum abstract ArrowUIDirection(String) from String to String
{
	var DOWN = 'down arrow';
	var UP = 'up arrow';
	var LEFT = 'left arrow';
	var RIGHT = 'right arrow';
}
