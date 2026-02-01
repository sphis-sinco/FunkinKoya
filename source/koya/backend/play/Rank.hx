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
}
