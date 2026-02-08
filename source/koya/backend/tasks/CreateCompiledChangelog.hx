package source.koya.backend.tasks;

import sys.FileSystem;
import sys.io.File;

using StringTools;

class CreateCompiledChangelog
{
	static function main()
	{
		var changelogs:Array<String> = File.getContent('dev/changelogs/order.txt').split('\n');

		var megaChangelog:String = '<!-- Generation Timestamp: ${Date.now()} -->\n\n';

		for (changelogFile in changelogs)
		{
			var path = 'dev/changelogs/${changelogFile.trim()}';
			// trace(path);

			if (!FileSystem.exists(path))
			{
				trace('$path doesn\'t exist');
				continue;
			}

			try
			{
				#if INCLUDE_CHANGELOG_FILEPATH
				megaChangelog += '<!-- $path -->\n';
				#end
				megaChangelog += File.getContent(path);
				megaChangelog += '\n';
			}
			catch (e)
			{
				trace('${e.message}');
			}
		}

		trace('Generated CHANGELOG.md');
		File.saveContent('CHANGELOG.md', megaChangelog);
	}
}
