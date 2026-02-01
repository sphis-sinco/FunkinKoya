package koya.backend.play;

using Math;

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

	public function grade():Rank
	{
		// Final Grade = ((Sick + Good) - (Miss)) / (Total Notes)
		var completionAmount:Float = tallyCompletion(noteRatingCounts);

		if (completionAmount >= Rank.RANK_AMAZING_THRESHOLD) return AMAZING;
		if (completionAmount >= Rank.RANK_EXCELLENT_THRESHOLD) return EXCELLENT;
		if (completionAmount >= Rank.RANK_GREAT_THRESHOLD) return GREAT;
		if (completionAmount >= Rank.RANK_GOOD_THRESHOLD) return GOOD;
		if (completionAmount >= Rank.RANK_OK_THRESHOLD) return OK;

		return BAD;
	}

	public function tallyCompletion(noteRatingCounts:Map<String, Int>):Float
	{
		if (noteRatingCounts == null) return 0;

		var positive = (noteRatingCounts.get('sick') + noteRatingCounts.get('good'));

		return CoolUtil.clampFloat((positive - notesMissed) / totalNotesHit, 0, 1); // Needs to be clamped to make sure Perfect ranks are saved properly
	}
}
