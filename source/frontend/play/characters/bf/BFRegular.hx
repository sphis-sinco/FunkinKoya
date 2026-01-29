package frontend.play.characters.bf;

class BFRegular extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'bf', isPlayer);
	}
}
