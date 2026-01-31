package koya.frontend.mainmenu;

import koya.backend.AssetPaths;

class MenuItem extends FunkinSprite
{
	public var item(default, null):String;

	override public function new(item:String, ?x:Float, ?y:Float)
	{
		super(x, y);

		frames = AssetPaths.fromSparrow('mainmenu/$item', 'ui');

		addPrefixAnim('idle', '$item idle');
		addPrefixAnim('selected', '$item selected');
		updateHitbox();

		makeOffsets();

		playAnim('idle');

		this.item = item;
	}

	public function makeOffsets()
	{
		playAnim('idle');
		centerOffsets();
		addOffset('idle', offset.x, offset.y);

		playAnim('selected');
		centerOffsets();
		addOffset('selected', offset.x, offset.y);
	}
}
