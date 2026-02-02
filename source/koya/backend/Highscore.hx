package koya.backend;

import koya.backend.play.Rank;
import koya.backend.save.Save;
import flixel.FlxG;
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

	public static function saveScore(song:String, score:Int = 0, ?diff:Difficulty = 0):Void
	{
		var daSong:String = formatToDifficulty(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score) setScore(daSong, score);
		}
		else
			setScore(daSong, score);
	}

	public static function saveWeekScore(week:String = '', score:Int = 0, ?diff:Difficulty = 0):Void
	{
		var daWeek:String = formatToDifficulty(week, diff);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score) setScore(daWeek, score);
		}
		else
			setScore(daWeek, score);
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

	public static function getScore(song:String, diff:Difficulty):Int
	{
		if (!songScores.exists(formatToDifficulty(song, diff))) setScore(formatToDifficulty(song, diff), 0);

		return songScores.get(formatToDifficulty(song, diff));
	}

	public static function getWeekScore(week:Int, diff:Difficulty):Int
	{
		if (!songScores.exists(formatToDifficulty('week' + week, diff))) setScore(formatToDifficulty('week' + week, diff), 0);

		return songScores.get(formatToDifficulty('week' + week, diff));
	}

	public static function load():Void
	{
		if (Save.songScores.get() != null) songScores = Save.songScores.get();
	}
}
