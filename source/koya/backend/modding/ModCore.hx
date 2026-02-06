package koya.backend.modding;

class ModCore
{
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

			if (KoyaAssets.exists('$path/$MOD_METADATA_FILE')) mods.push(mod);
		}
		#end

		trace('Reloaded with ${mods.length} mods found');
	}
}
