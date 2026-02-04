package koya.backend.songs;

import koya.frontend.scenes.play.PlayState;

class EventParser
{
	public static final splitText:String = '/';

	public static function sendEvent(name:String, value:String)
	{
		name = name.toLowerCase();
		var vals:Array<String> = value.split(splitText);

		if (name == 'playanim') playAnim(vals);
	}

	public static function playAnim(values:Array<String>)
	{
		var character:String = values[0];
		var animationName:String = values[1];

		switch (character)
		{
			case '0', 'bf', 'boy', 'boyfriend', 'player':
				PlayState.instance.currentStage.boyfriend?.playAnim(animationName);
			case '1', 'dad', 'opponent':
				PlayState.instance.currentStage.dad?.playAnim(animationName);
			case '2', 'gf', 'girl', 'girlfriend', 'damsel':
				PlayState.instance.currentStage.gf?.playAnim(animationName);
		}
	}

	public static function pause() {}
	public static function unpause() {}
}
