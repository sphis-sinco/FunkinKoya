package koya.frontend.scenes.menustates;

import flixel.FlxG;
import koya.frontend.scenes.freeplay.FreeplayState;
import koya.frontend.ui.menustate.MenuState;

class MainMenuState extends MenuState
{
	override public function new()
	{
		super('mainmenu/', Vertical);

		itemList = ['story mode', 'freeplay', 'support', 'options', #if MOD_SUPPORT 'mods' #end];
	}

	override function accept(item:String)
	{
		super.accept(item);

		switch (item)
		{
			case 'story mode':
				trace('the tale you play');
				FlxG.switchState(() -> new StoryModeState());
				transitioning = true;
			case 'freeplay':
				trace('FREE');
				FlxG.switchState(() -> new FreeplayState());
				transitioning = true;
			case 'support':
				trace('mone?');
				FlxG.openURL('https://ko-fi.com/sphis');
			case 'options':
				trace('change is supported');
				OptionsMenuState.inGameplay = false;
				FlxG.switchState(() -> new OptionsMenuState());
				transitioning = true;
			case 'mods':
				trace('change is supported');
				FlxG.switchState(() -> new ModsMenuState());
				transitioning = true;
		}
	}
}
