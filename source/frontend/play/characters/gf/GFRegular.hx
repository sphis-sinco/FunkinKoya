package frontend.play.characters.gf;

class GFRegular extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'gf', isPlayer);
	}
}
