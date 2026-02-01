package koya.backend.play;

class ResultsData
{
	/**
		HIT NOTES.
		NOT ALL THE NOTES IN THE SONG.
	**/
	public var totalNotesHit:Int = 0;

	/**
		Missed by flying away
	**/
	public var notesMissed:Int = 0;

	public var noteRatingCounts:Map<String, Int>;

	public function new()
	{
		reset();
	}

	public function earnMiss()
	{
		notesMissed++;
	}

	public function earnRating(rating:String)
	{
		if (noteRatingCounts.exists(rating)) noteRatingCounts.set(rating, noteRatingCounts.get(rating) + 1);
	}

	public function reset()
	{
		totalNotesHit = 0;
		notesMissed = 0;
		noteRatingCounts = ['shit' => 0, 'bad' => 0, 'good' => 0, 'sick' => 0,];
	}

	public function toString()
	{
		var data:Dynamic =
			{
				totalNotesHit: totalNotesHit,
				notesMissed: notesMissed,
			};

		for (rating => count in noteRatingCounts)
			Reflect.setField(data, '${rating}Count', count);

		return Std.string(data);
	}
}
