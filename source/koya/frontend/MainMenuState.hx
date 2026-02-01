package koya.frontend;

import flixel.FlxG;
import koya.frontend.freeplay.FreeplayState;
import koya.frontend.ui.menustate.MenuState;

class MainMenuState extends MenuState
{
	override public function new()
	{
		super('mainmenu/', Vertical);

		itemList = [
			'story mode',
			'freeplay',
			'support',
			// 'options',
		];
	}

	override function accept(item:String)
	{
		super.accept(item);

		switch (item)
		{
			case 'story mode':
				trace('the tale you play');
			case 'freeplay':
				trace('FREE');
				FlxG.switchState(() -> new FreeplayState());
				transitioning = true;
			case 'support':
				trace('mone?');
				FlxG.openURL('https://ko-fi.com/sphis');
			case 'options':
				trace('change is supported');
		}
	}
}
