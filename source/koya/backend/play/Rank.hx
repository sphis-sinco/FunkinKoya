package koya.backend.play;

enum abstract Rank(String) from String to String
{
	var BAD = 'BAD';
	var OK = 'OK';

	var GOOD = 'GOOD';
	var GREAT = 'GREAT';

	var EXCELLENT = 'EXCELLENT';
	var AMAZING = 'AMAZING';

	/** Percent for AMAZING rank **/
	public static final RANK_AMAZING_THRESHOLD:Float = 1.00;

	/** Percent for EXCELLENT rank **/
	public static final RANK_EXCELLENT_THRESHOLD:Float = 0.80;

	/** Percent for GREAT rank **/
	public static final RANK_GREAT_THRESHOLD:Float = 0.60;

	/** Percent for GOOD rank **/
	public static final RANK_GOOD_THRESHOLD:Float = 0.40;

	/** Percent for OK rank **/
	public static final RANK_OK_THRESHOLD:Float = 0.20;

	public function toLowerCase()
		return this.toLowerCase();

	/** Score the Rank! Give you score. **/
	public function getScore():Int
	{
		if (this == AMAZING) return 100;

		if (this == EXCELLENT) return 80;

		if (this == GREAT) return 40;

		if (this == GOOD) return 20;

		if (this == OK) return 10;

		return 0;
	}

	/**
		Compare ranks `a` and `b` and

		(if `findHighest`) get the higher score

		(if not `findHighest`) get the lower score

		@param a Rank
		@param b Other Rank
		@param findHighest Should it check for the lower score?
	**/
	public static function compareRanks(a:Rank, b:Rank, findHighest:Bool = true)
	{
		var aScore:Int = a.getScore();
		var bScore:Int = b.getScore();

		if (findHighest)
		{
			if (aScore > bScore) return a;
			else
				return b;
		}
		else
		{
			if (aScore < bScore) return a;
			else
				return b;
		}

		return null;
	}
}
