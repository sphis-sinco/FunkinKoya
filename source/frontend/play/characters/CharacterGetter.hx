package frontend.play.characters;

class CharacterGetter
{
	public static function getCharacter(char:String, ?isPlayer:Bool, ?x:Float, ?y:Float):Character
	{
		return new Character(x, y, char, isPlayer);
	}
}
