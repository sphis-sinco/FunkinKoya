package koya.backend.play;

using Math;

class ResultsData
{
	/** Notes hit in the song **/
	public var totalNotesHit:Int = 0;

	/** Notes missed by not hitting notes that were there **/
	public var notesMissed:Int = 0;

	/** A rating and the amount of times it was received **/
	public var noteRatingCounts:Map<String, Int>;

	/** Reset all the variables **/
	public function new()
	{
		reset();
	}

	/** Add a miss **/
	public function earnMiss()
	{
		notesMissed++;
	}

	/**
		Add a Rating if `noteRatingCounts` has it

		@param rating The rating
	**/
	public function earnRating(rating:String)
	{
		if (noteRatingCounts.exists(rating)) noteRatingCounts.set(rating, noteRatingCounts.get(rating) + 1);
	}

	/** Reset all the variables **/
	public function reset()
	{
		totalNotesHit = 0;
		notesMissed = 0;
		noteRatingCounts = ['shit' => 0, 'bad' => 0, 'good' => 0, 'sick' => 0,];
	}

	/** Return a JSON of the results data **/
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

	/** Return grade percentage **/
	public function gradePercent():Float
	{
		return tallyCompletion(noteRatingCounts);
	}

	/** Return grade rank **/
	public function grade():Rank
	{
		// Final Grade = ((Sick + Good) - (Miss)) / (Total Notes)
		var completionAmount:Float = gradePercent();

		if (completionAmount >= Rank.RANK_AMAZING_THRESHOLD) return AMAZING;
		if (completionAmount >= Rank.RANK_EXCELLENT_THRESHOLD) return EXCELLENT;
		if (completionAmount >= Rank.RANK_GREAT_THRESHOLD) return GREAT;
		if (completionAmount >= Rank.RANK_GOOD_THRESHOLD) return GOOD;
		if (completionAmount >= Rank.RANK_OK_THRESHOLD) return OK;

		return BAD;
	}

	/** Calculate grade percent **/
	public function tallyCompletion(noteRatingCounts:Map<String, Int>):Float
	{
		if (noteRatingCounts == null) return 0;

		var positive = (noteRatingCounts.get('sick') + noteRatingCounts.get('good'));

		return CoolUtil.clampFloat((positive - notesMissed) / totalNotesHit, 0, 1); // Needs to be clamped to make sure Perfect ranks are saved properly
	}
}
