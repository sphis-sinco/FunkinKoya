package koya.frontend.scenes.menustates;

import koya.backend.modding.ModCore;

class ModsMenuState extends OptionsMenuState
{
	override function addItems()
	{
		for (mod in ModCore.allMods)
		{
			addItem(ModCore.getModName(mod), ModCore.enabledMods.contains(mod), function() {
				if (ModCore.enabledMods.contains(mod)) ModCore.enabledMods.remove(mod);
				else
					ModCore.enabledMods.push(mod);
			});
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mod = this.itemList[currentSelection];
		valueText.text = 'Mod: ${ModCore.getModName(mod)}${(ModCore.modMetadatas.get(mod)?.name != null) ? ' (${mod})' : ''}\n'
			+ 'Description: ${ModCore.modMetadatas.get(mod)?.description ?? 'N / A'}\n'
			+ 'Enabled: ${this.itemListValues.get(mod)}';
	}
}
