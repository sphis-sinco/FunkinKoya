package frontend.ui;

import backend.AssetPaths;
import flixel.FlxSprite;

class ArrowUI extends FlxSprite
{
	override public function new(direction:ArrowUIDirection, ?x:Float, ?y:Float)
	{
		super(x, y);

		frames = AssetPaths.fromSparrow('ui_arrows', 'ui');
		animation.addByPrefix('arrow', direction, 24);
		animation.play('arrow');
		
		updateHitbox();
	}
}

enum abstract ArrowUIDirection(String) from String to String
{
	var DOWN = 'down arrow';
	var UP = 'up arrow';
	var LEFT = 'left arrow';
	var RIGHT = 'right arrow';
}
