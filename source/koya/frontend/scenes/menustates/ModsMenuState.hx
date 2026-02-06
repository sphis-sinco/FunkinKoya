package koya.frontend.scenes.menustates;

import flixel.FlxG;
import koya.backend.modding.ModCore;

class ModsMenuState extends OptionsMenuState
{
	override function addItems()
	{
		for (mod in ModCore.allMods)
		{
			addItem(mod, ModCore.enabledMods.contains(mod), function() {
				if (ModCore.enabledMods.contains(mod)) ModCore.enabledMods.remove(mod);
				else
					ModCore.enabledMods.push(mod);
			});

			FlxG.log.add('$mod : ${ModCore.modMetadatas.get(mod)}');
			FlxG.log.add('$mod.description : ${ModCore.modMetadatas.get(mod).description}');
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var mod = this.itemList[currentSelection];

		valueText.text = 'Mod: ${ModCore.getModName(mod)}${(ModCore.modMetadatas.get(mod)?.name != null) ? ' (${mod})' : ''}\n'
			+ 'Description: ${ModCore.modMetadatas.get(mod)?.description}\n'
			+ 'Enabled: ${this.itemListValues.get(mod)}';
	}
}
