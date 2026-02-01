package koya.frontend;

import koya.frontend.ui.menustate.MenuState;

class MainMenuState extends MenuState
{

	override public function new() {
		super('mainmenu/', Vertical);

		itemList = [
			'story mode',
			'freeplay',
			'support',
			// 'options',
		];
	}
	
}