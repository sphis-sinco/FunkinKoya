package koya.frontend;

import koya.backend.songs.SongList;
import koya.frontend.ui.menustate.MenuState;

class StoryModeState extends MenuState
{
	override public function new()
	{
		super('storymode/', Horizontal);

		this.itemList = SongList.weekList.textList;
	}

	override function accept(item:String)
	{
		super.accept(item);

		switch (item.toLowerCase())
		{
			case 'tutorial', 'week1', 'week2':
				loadWeek(item.toLowerCase());
		}
	}

	public function loadWeek(week:String) {}
}
