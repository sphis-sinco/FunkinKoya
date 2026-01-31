package frontend.play.songs;

class SongClass
{
	public static function getSongClass(song:String):SongClass
		return SongClassGetter.getSongClass(song);

	public function new() {}

	public function runFunction(name:String, ?args:Map<String, Dynamic>)
	{
		if (Reflect.hasField(this, name))
		{
			var field:Dynamic = Reflect.field(this, name);

			if (Reflect.isFunction(field))
			{
				try
				{
					field(args ?? []);
				}
				catch (e)
				{
					trace(e.message);
				}
			}
		}

		return null;
	}
}
