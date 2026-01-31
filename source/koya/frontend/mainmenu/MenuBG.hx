package koya.frontend.mainmenu;

import koya.backend.AssetPaths;

class MenuBG extends FunkinSprite
{
	override public function new(pink:Bool = false, ?x:Float, ?y:Float)
	{
		super(x, y);

		if (pink) loadGraphic(AssetPaths.image('mainmenu/bg_pink', 'ui'));
		else
			loadGraphic(AssetPaths.image('mainmenu/bg_desat', 'ui'));
	}
}
