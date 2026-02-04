package koya.frontend.scenes.play.characters;

import koya.frontend.scenes.play.characters.ogchars.*;
import koya.frontend.scenes.play.characters.unogchars.*;
import koya.frontend.scenes.play.characters.bf.*;
import koya.frontend.scenes.play.characters.gf.*;
import koya.frontend.scenes.play.characters.parents.*;

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
			case 'pico':
				return new Pico(x, y, isPlayer);
			case 'monster':
				return new Monster(x, y, isPlayer);
		}

		return new Character(x, y, char, isPlayer);
	}
}
