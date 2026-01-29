package frontend.play.characters.parents;

class DaddyDearest extends Character
{
	override public function new(?x:Float, ?y:Float, ?isPlayer:Bool = false)
	{
		super(x, y, 'dad', isPlayer);
	}
}
