package koya.backend.modding;

import haxe.Json;

class ModCore
{
	public static var MOD_MIN_API_VERSION:Float = 0.0;

	public static final MOD_DIRECTORY:String = 'mods';
	public static final MOD_METADATA_FILE:String = 'meta.json';

	public static var mods:Array<String> = [];

	public static function init()
	{
		reloadMods();
	}

	public static function reloadMods()
	{
		reloadModList();
	}

	public static function reloadModList()
	{
		mods = [];

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
							'The mod "$mod" is running on an unsupported version : ${modMeta.api_version}\n\nMinimum supported version ${MOD_MIN_API_VERSION}');
					}
				}
				catch (e)
				{
					CoolUtil.alert('"$mod" metadata JSON Parsing Error', 'Could not parse mod metajson file:\n\nError Message: ${e.message}');
					continue;
				}

				mods.push(mod);
			}
		}
		#end

		trace('Reloaded with ${mods.length} mods found');
	}
}
