package koya.frontend.play.characters.gf;

import koya.backend.AssetPaths;

class GFSpooky extends GFRegular
{
	public var monster:Bool = false;

	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool, ?monster:Bool = false)
	{
		super(x, y, isPlayer, 'gf-spooky');
		this.monster = monster;
	}

	override function getFrames()
	{
		frames = AssetPaths.getAnimateAtlas('characters/girlfriend-spooky${monster ? '-monster' : ''}', 'characters');
	}
}
