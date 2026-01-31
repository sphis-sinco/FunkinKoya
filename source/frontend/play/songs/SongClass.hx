package frontend.play.songs;

class SongClass
{
	public static function getSongClass(song:String):SongClass
		return SongClassGetter.getSongClass(song);

	public function new() {}

	public function runFunction(name:String, ?args:Map<String, Dynamic>)
	{
		var field:Dynamic = Reflect.field(this, name);

		if (field != null)
			try
			{
				if (!['update'].contains(name))
					trace('Running $name with args: $args');
				return field(args ?? []);
			}
			catch (e)
			{
				if (!['update'].contains(name))
					trace(e.message);
			}

		return null;
	}
}
