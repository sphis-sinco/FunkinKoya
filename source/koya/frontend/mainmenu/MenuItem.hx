package koya.frontend.mainmenu;

import koya.backend.AssetPaths;

class MenuItem extends FunkinSprite
{
	public var item(default, null):String;

	public var sparrowPath(get, never):String;

	function get_sparrowPath():String
		return 'mainmenu/$item';

	override public function new(item:String, ?x:Float, ?y:Float)
	{
		super(x, y);

		this.item = item;
		frames = AssetPaths.fromSparrow(sparrowPath, 'ui');

		addPrefixAnim('idle', '$item idle');
		addPrefixAnim('selected', '$item selected');
		updateHitbox();

		makeOffsets();

		playAnim('idle');
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
