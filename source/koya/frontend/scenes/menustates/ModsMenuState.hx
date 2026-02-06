package koya.frontend.scenes.menustates;

import koya.backend.modding.ModCore;

class ModsMenuState extends OptionsMenuState
{
	override function addItems()
	{
		for (mod in ModCore.allMods)
		{
			addItem('$mod', ModCore.enabledMods.contains(mod), function() {
				if (ModCore.enabledMods.contains(mod)) ModCore.enabledMods.remove(mod);
				else
					ModCore.enabledMods.push(mod);
			});
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		valueText.text = 'Mod: ${this.itemList[currentSelection]}\n' + 'Enabled: ${this.itemListValues.get(this.itemList[currentSelection])}';
	}
}
