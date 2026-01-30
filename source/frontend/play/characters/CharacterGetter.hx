package frontend.play.characters;

import flixel.math.FlxPoint;
import frontend.play.characters.bf.*;
import frontend.play.characters.gf.*;
import frontend.play.characters.parents.*;

class CharacterGetter
{
	public static function getCharacter(char:String, ?isPlayer:Bool, ?x:Float, ?y:Float):Character
	{
		switch (char)
		{
			case 'bf': return new BFRegular(x, y, isPlayer);
			case 'gf': return new GFRegular(x, y, isPlayer);
			case 'dad': return new DaddyDearest(x, y, isPlayer);
		}

		return new Character(x, y, char, isPlayer);
	}

	public static function getCharacterStartingCamPos(startingCamPos:FlxPoint, char:String)
	{
		if (startingCamPos == null) return;

		switch(char)
		{}
	}
}
