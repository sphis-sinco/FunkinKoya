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
			case LOSING: playAnim('losing');
			case _: playAnim('normal');
		}

		return state;
	}

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		frames = AssetPaths.fromSparrow('healthIcons/$char', 'characters');
		
		addPrefixAnim('normal', '$char normal');
		addPrefixAnim('losing', '$char lose');

		updateHitbox();

		flipX = isPlayer;
		scrollFactor.set();
	}
}

enum HealthIconState
{
	WINNING;
	NORMAL;
	LOSING;
}
