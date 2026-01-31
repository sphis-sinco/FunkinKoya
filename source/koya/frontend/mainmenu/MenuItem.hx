package koya.frontend.mainmenu;

import koya.backend.AssetPaths;

class MenuItem extends FunkinSprite
{
	public var item(default, null):String;

	override public function new(item:String, ?x:Float, ?y:Float)
	{
		super(x, y);

		frames = AssetPaths.fromSparrow('mainmenu/$item', 'mainmenu');

		addPrefixAnim('idle', '$item idle');
		addPrefixAnim('selected', '$item selected');

		playAnim('idle');

		this.item = item;
	}
}
