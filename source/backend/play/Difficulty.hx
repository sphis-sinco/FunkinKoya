package backend.play;

enum abstract Difficulty(Int) from Int to Int
{
	var EASY = 0;
	var NORMAL = 1;
	var HARD = 2;

	public static var list:Array<Difficulty> = [
		EASY,
		NORMAL,
		HARD
	];
	
	public static var stringList:Array<String> = [
		EASY.toString(),
		NORMAL.toString(),
		HARD.toString()
	];

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

	public function chartSuffix():String
	{
		if (this == EASY)
			return '-${toString()}';
		if (this == HARD)
			return '-${toString()}';

		return '';
	}

	public function toString():String
	{
		if (this == EASY)
			return 'easy';
		if (this == NORMAL)
			return 'normal';
		if (this == HARD)
			return 'hard';

		return '';
	}
}
