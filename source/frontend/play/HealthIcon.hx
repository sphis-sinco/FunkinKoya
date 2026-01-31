package frontend.play;

import backend.AssetPaths;
import flixel.FlxSprite;

class HealthIcon extends FunkinSprite
{
	public var state(default, set):HealthIconState;

	function set_state(state:HealthIconState):HealthIconState
	{
		switch (state)
		{
			// case WINNING: playAnim('');
			case LOSING:
				playAnim('losing');
			case _:
				playAnim('normal');
		}

		return state;
	}

	public var char(default, set):String = '';

	function set_char(char:String):String
	{
		frames = AssetPaths.fromSparrow('healthIcons/$char', 'characters');

		addPrefixAnim('normal', '$char normal');
		addPrefixAnim('losing', '$char lose');

		updateHitbox();

		flipX = isPlayer;

		return char;
	}

	public var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		flipX = isPlayer;
		this.char = char;
		scrollFactor.set();
	}
}

enum HealthIconState
{
	WINNING;
	NORMAL;
	LOSING;
}
