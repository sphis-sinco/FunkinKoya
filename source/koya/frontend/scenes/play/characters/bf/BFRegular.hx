package koya.frontend.scenes.play.characters.bf;

class BFRegular extends Character
{
	public var bfVersion:String = 'bf';

	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false, ?bfVersion:String = 'bf')
	{
		super(x, y, bfVersion, isPlayer);
	}
}
