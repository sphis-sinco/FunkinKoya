package koya.backend.modding;

import koya.backend.save.Save;
import haxe.Json;

class ModCore
{
	/** Minimum supported mod API **/
	public static var MOD_MIN_API_VERSION:Float = 0.1;

	/** Directory for mods to be looked for **/
	public static final MOD_DIRECTORY:String = 'mods';

	/** Mod metadata filename **/
	public static final MOD_METADATA_FILE:String = 'meta.json';

	/** Array of all mods that exists **/
	public static var allMods:Array<String> = [];

	/** Array of enabled mods, just returns the save data `enabledMods` **/
	public static var enabledMods(get, never):Array<String>;

	static function get_enabledMods():Array<String>
		return Save.enabledMods?.get() ?? [];

	/** Map of mod metadatas **/
	public static var modMetadatas:Map<String, ModMetadata> = [];

	/**
		Get `mod` display name or ID

		@param mod Desired mod
	**/
	public static function getModName(mod:String)
	{
		return modMetadatas.get(mod)?.name ?? mod;
	}

	/** Runs `reloadMods` **/
	public static function init()
	{
		reloadMods();
	}

	/** Performs a reload on all things relating to modding **/
	public static function reloadMods()
	{
		reloadModList();
	}

	/** Removes current mods and gets the new mods **/
	public static function reloadModList()
	{
		allMods = [];
		modMetadatas.clear();

		#if MOD_SUPPORT
		for (mod in KoyaAssets.readDirectory(MOD_DIRECTORY))
		{
			var path:String = '$MOD_DIRECTORY/$mod';

			if (KoyaAssets.exists('$path/$MOD_METADATA_FILE'))
			{
				try
				{
					var modMeta:ModMetadata = Json.parse(KoyaAssets.getText('$path/$MOD_METADATA_FILE'));

					if (modMeta.api_version < MOD_MIN_API_VERSION)
					{
						CoolUtil.alert('"$mod" running on unsupported version',
							'The mod "$mod" is running on an unsupported version : ${modMeta.api_version}\n\n' +
							'Minimum supported version ${MOD_MIN_API_VERSION}\n' + 'The mod will still be added but if things go wrong don\'t be surprised');
					}

					modMeta.authors ??= [];
					modMeta.description ??= 'N / A';

					modMetadatas.set(mod, modMeta);
				}
				catch (e)
				{
					CoolUtil.alert('"$mod" metadata JSON Parsing Error', 'Could not parse mod metajson file:\n\n' + 'Error Message: ${e.message}');
					continue;
				}

				allMods.push(mod);
			}
		}
		#end

		trace('Reloaded with ${allMods.length} mod(s) found');
		for (mod in allMods)
		{
			var meta = modMetadatas.get(mod);

			var name = getModName(mod);
			var version = (meta.mod_version != null) ? ' ${meta.mod_version}' : '';

			trace(' * $name$version for api : ${meta.api_version}');
		}

		for (mod in enabledMods)
			if (!allMods.contains(mod)) enabledMods.remove(mod);
	}
}
