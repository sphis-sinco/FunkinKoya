package koya.backend.songs;

import koya.frontend.scenes.play.PlayState;

using StringTools;

class EventParser
{
	/** Text character that splits event values **/
	public static final splitText:String = '/';

	/** Runs Initalization functions for maybe some sprite groups for some evens **/
	public static function init() {}

	/**
		Run event functions

		@param name Event Name
		@param value Event Value (not split)
	**/
	public static function sendEvent(name:String, value:String)
	{
		name = name.toLowerCase();
		var vals:Array<String> = value.split(splitText);

		var removed = ['subtitle', 'removesubtitles'];
		if (removed.contains(name)) trace('I removed it');

		if (name == 'playanim') playAnim(vals);
	}

	/**
		Play Animation Event

		@param values Event Value (split)
	**/
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

	/** This is for some events that might have something change when paused **/
	public static function pause() {}

	/** This is for some events that might have something change when unpaused **/
	public static function unpause() {}
}
