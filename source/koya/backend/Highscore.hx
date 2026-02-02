package koya.backend;

import koya.backend.play.Rank;
import koya.backend.save.Save;
import koya.backend.play.Difficulty;

class Highscore
{
	public static var songScores:Map<String, Int> = [];
	public static var songRanks:Map<String, Rank> = [];

	public static function saveRank(songOrWeek:String, rank:Rank, diff:Difficulty)
	{
		var formattedField:String = formatToDifficulty(songOrWeek, diff);

		if (songRanks.exists(formattedField))
		{
			if (Rank.compareRanks(songRanks.get(formattedField), rank) == rank) setRank(formattedField, rank);
		}
		else
			setRank(formattedField, rank);

	}

	static function setRank(song:String, rank:Rank):Void
	{
		songRanks.set(song, rank);

		Save.songRanks.set(songRanks);
		Save.flush();
	}

	public static function saveScore(songOrWeek:String, score:Int = 0, ?diff:Difficulty = 0):Void
	{
		var formattedField:String = formatToDifficulty(songOrWeek, diff);

		if (songScores.exists(formattedField))
		{
			if (songScores.get(formattedField) < score) setScore(formattedField, score);
		}
		else
			setScore(formattedField, score);
	}

	static function setScore(song:String, score:Int):Void
	{
		songScores.set(song, score);

		Save.songScores.set(songScores);
		Save.flush();
	}

	public static function formatToDifficulty(song:String, diff:Difficulty):String
	{
		var daSong:String = song;
		daSong += diff.chartSuffix();
		return daSong;
	}

	public static function getScore(songOrWeek:String, diff:Difficulty):Int
	{
		if (!songScores.exists(formatToDifficulty(songOrWeek, diff))) setScore(formatToDifficulty(songOrWeek, diff), 0);

		return songScores.get(formatToDifficulty(songOrWeek, diff));
	}

	public static function load():Void
	{
		if (Save.songScores.get() != null) songScores = Save.songScores.get();
		if (Save.songRanks.get() != null) songRanks = Save.songRanks.get();
	}
}
