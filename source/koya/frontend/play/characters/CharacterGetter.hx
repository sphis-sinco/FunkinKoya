package koya.frontend.play.characters;

import koya.frontend.play.characters.ogchars.*;
import koya.frontend.play.characters.unogchars.*;
import koya.frontend.play.characters.bf.*;
import koya.frontend.play.characters.gf.*;
import koya.frontend.play.characters.parents.*;

using StringTools;

class CharacterGetter
{
	public static function getCharacter(char:String, ?isPlayer:Bool, ?x:Float, ?y:Float):Character
	{
		switch (char.toLowerCase())
		{
			case 'bf':
				return new BFRegular(x, y, isPlayer);
			case 'bf-spooky':
				return new BFSpooky(x, y, isPlayer);
			case 'gf':
				return new GFRegular(x, y, isPlayer);
			case 'gf-spooky', 'gf-spooky-monster':
				return new GFSpooky(x, y, isPlayer, char.contains('monster'));
			case 'dad':
				return new DaddyDearest(x, y, isPlayer);
			case 'spooky':
				return new Spooky(x, y, isPlayer);
			case 'monster':
				return new Monster(x, y, isPlayer);
		}

		return new Character(x, y, char, isPlayer);
	}
}
