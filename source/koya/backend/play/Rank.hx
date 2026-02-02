package koya.backend.play;

enum abstract Rank(String) from String to String
{
	var BAD = 'BAD';
	var OK = 'OK';

	var GOOD = 'GOOD';
	var GREAT = 'GREAT';

	var EXCELLENT = 'EXCELLENT';
	var AMAZING = 'AMAZING';

	public static final RANK_AMAZING_THRESHOLD:Float = 1.00;
	public static final RANK_EXCELLENT_THRESHOLD:Float = 0.80;
	public static final RANK_GREAT_THRESHOLD:Float = 0.60;
	public static final RANK_GOOD_THRESHOLD:Float = 0.40;
	public static final RANK_OK_THRESHOLD:Float = 0.20;

	public function toLowerCase()
		return this.toLowerCase();

	public function getScore():Int
	{
		if (this == AMAZING) return 100;

		if (this == EXCELLENT) return 80;

		if (this == GREAT) return 40;

		if (this == GOOD) return 20;

		if (this == OK) return 10;

		return 0;
	}

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
