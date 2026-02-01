package koya.frontend.ui.menustate;

import koya.backend.AssetPaths;

class MenuBG extends FunkinSprite
{
	override public function new(pink:Bool = false, ?x:Float, ?y:Float)
	{
		super(x, y);

		if (pink) loadGraphic(AssetPaths.image('bg_pink', 'ui'));
		else
			loadGraphic(AssetPaths.image('bg_desat', 'ui'));
	}
}
