package koya.frontend.scenes.menustates;

import koya.frontend.ui.menustate.MenuState;

class OptionsMenuState extends MenuState
{
	public var values(get, never):Map<String, Dynamic>;

	function get_values():Map<String, Dynamic>
	{
		var vals:Map<String, Dynamic> = [];

		vals.set('fpsCounter', true);
		vals.set('chart editor autosave', true);

		return vals;
	}

	override public function new()
	{
		super('', Vertical);

		this.itemIncOffset = 160;
		this.itemList = ['fpsCounter', '', 'chart editor autosave'];
		this.text = true;
	}

	override function select(change:Int = 0)
	{
		super.select(change);

		if (text) for (item in itemsTextGroup)
		{
			item.text = '${this.itemList[item.ID]} | ${this.values.get(this.itemList[item.ID])}';
		}
	}
}
