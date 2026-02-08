package koya.backend.play;

enum abstract Difficulty(Int) from Int to Int
{
	var EASY = 0;
	var NORMAL = 1;
	var HARD = 2;

	/** List of difficultys **/
	public static var list:Array<Difficulty> = [EASY, NORMAL, HARD];

	/** List of difficultys as a string **/
	public static var stringList:Array<String> = [EASY.toString(), NORMAL.toString(), HARD.toString()];

	/** 
		Change difficulty by `amount`

		@param amount Change amoung
	**/
	public function change(amount:Int):Difficulty
	{
		var diffInt = toInt();
		diffInt += amount;

		if (diffInt < EASY.toInt()) diffInt = EASY;
		if (diffInt > HARD.toInt()) diffInt = HARD;

		return diffInt;
	}

	/**
		Mainly for if functions and
		comparing a difficulty to a difficulty
	**/
	public function toInt():Int
		return this;

	/** Get chart suffix of difficulty **/
	public function chartSuffix():String
	{
		if (this == NORMAL) return '';

		return '-${toString()}';
	}

	/** Return string version of difficulty name **/
	public function toString():String
	{
		if (this == EASY) return 'easy';
		if (this == NORMAL) return 'normal';
		if (this == HARD) return 'hard';

		return '';
	}
}
