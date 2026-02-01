package koya.frontend.play;

import lime.utils.Assets;
import koya.backend.AssetPaths;
import flixel.FlxSprite;

class HealthIcon extends FunkinSprite
{
	public var state(default, set):HealthIconState;

	function set_state(state:HealthIconState):HealthIconState
	{
		if (state == null) state = NORMAL;

		if (anim.getNameList().length > 0) switch (state)
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
		if (!Assets.exists(AssetPaths.image('healthIcons/$char', 'characters'))) char = 'face';

		frames = AssetPaths.fromSparrow('healthIcons/$char', 'characters');

		addPrefixAnim('normal', '$char normal');
		addPrefixAnim('losing', '$char lose');

		updateHitbox();

		flipX = isPlayer;
		state = state;

		return char;
	}

	public var isPlayer:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		this.isPlayer = isPlayer;
		this.state = NORMAL;
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
