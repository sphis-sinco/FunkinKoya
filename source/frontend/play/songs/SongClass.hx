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

	public function log(log:Dynamic)
	{
		trace('> $song : $log');
	}

	public function runFunction(name:String, ?args:Map<String, Dynamic>)
	{
		var field:Dynamic = Reflect.field(this, name);

		var preventSpamTraces:Array<String> = ['update', 'keyShit'];

		try
		{
				if (!preventSpamTraces.contains(name))
					log('Running $name with args: $args');
				return field(args ?? []);
		}
		catch (e)
		{
			if (!preventSpamTraces.contains(name))
			{
				var err:String = e.message;

				if (err.toLowerCase() == 'null function pointer')
					err = 'Missing function: $name';

				var tracesA:Array<String> = traces.get(song);

				if (!tracesA.contains(e.message))
				{
					tracesA.push(e.message);
					log(e.message);
				}

				traces.set(song, tracesA);
			}
		}

		return null;
	}
}
