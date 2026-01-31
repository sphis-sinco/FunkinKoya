package frontend.play.songs;

class SongClass
{
	public static function getSongClass(song:String):SongClass
		return SongClassGetter.getSongClass(song);

	public var song:String = '';

	public function new(song:String)
	{
		this.song = song;

		if (!traces.exists(song))
			traces.set(song, []);
	}

	public static var traces:Map<String, Array<String>> = [];

	public function runFunction(name:String, ?args:Map<String, Dynamic>)
	{
		var field:Dynamic = Reflect.field(this, name);

		try
		{
			if (!['update'].contains(name))
				trace('Running $name with args: $args');
			return field(args ?? []);
		}
		catch (e)
		{
			if (!['update'].contains(name))
			{
				var tracesA:Array<String> = traces.get(song);

				if (!tracesA.contains(e.message))
				{
					tracesA.push(e.message);
					trace(e.message);
				}

				traces.set(song, tracesA);
			}
		}

		return null;
	}
}
