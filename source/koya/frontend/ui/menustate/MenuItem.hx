package koya.frontend.ui.menustate;

import koya.backend.AssetPaths;

class MenuItem extends FunkinSprite
{
	public var item(default, null):String;

	override public function new(item:String, pathPrefix:String, ?x:Float, ?y:Float)
	{
		super(x, y);

		this.item = item;
		frames = AssetPaths.fromSparrow('$pathPrefix$item', 'ui');

		addPrefixAnim('idle', '$item idle');
		addPrefixAnim('selected', '$item selected');
		makeOffsets();
		updateHitbox();

		playAnim('idle');
		updateHitbox();
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
