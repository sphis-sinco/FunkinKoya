package backend.play;

enum abstract Difficulty(Int) from Int to Int
{
	var EASY = 0;
	var NORMAL = 1;
	var HARD = 2;

	public function chartSuffix():String
	{
		if (this == EASY) return '-easy';
		if (this == HARD) return '-hard';

		return '';
	}
}
