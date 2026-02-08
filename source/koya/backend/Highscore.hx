package koya.backend;

import koya.backend.play.Rank;
import koya.backend.save.Save;
import koya.backend.play.Difficulty;

using StringTools;

class Highscore
{
	/**
		Map of the song or week scores with difficulty included

		example:
		week1-hard -> 091829
		blammed -> 34838
		monster-easy -> 2928
	**/
	public static var songScores:Map<String, Int> = [];

	/**
		Map of the song or week ranks with difficulty included

		example:
		tutorial-easy -> BAD
		pico-hard -> EXCELLENT
		south -> OKAY
	**/
	public static var songRanks:Map<String, Rank> = [];

	/**
		Save `rank` for `songOrWeek` for difficulty: `diff`
		if `rank` is better then `songOrWeek`'s already existing(?) rank

		@param songOrWeek the song or week the ranks being saved to
		@param rank the rank to save
		@param diff song or week difficulty
	**/
	public static function saveRank(songOrWeek:String, rank:Rank, diff:Difficulty)
	{
		if (songOrWeek.trim() == '') return;

		var formattedField:String = formatToDifficulty(songOrWeek, diff);

		if (songRanks.exists(formattedField))
		{
			if (Rank.compareRanks(songRanks.get(formattedField), rank) == rank) setRank(formattedField, rank);
		}
		else
			setRank(formattedField, rank);
	}

	/**
		Set the rank for `songOrWeek` to be `rank`

		@param songOrWeek the song or week the ranks being saved to
		@param rank the rank to save
	**/
	static function setRank(songOrWeek:String, rank:Rank):Void
	{
		if (songOrWeek.trim() == '') return;

		songRanks.set(songOrWeek, rank);

		Save.songRanks.set(songRanks);
		Save.flush();
	}

	/**
		Save `score` for `songOrWeek` for difficulty: `diff`
		if `score` is better then `songOrWeek`'s already existing(?) score

		@param songOrWeek the song or week the scores being saved to
		@param score the score to save
		@param diff song or week difficulty
	**/
	public static function saveScore(songOrWeek:String, score:Int = 0, ?diff:Difficulty = 0):Void
	{
		if (songOrWeek.trim() == '') return;

		var formattedField:String = formatToDifficulty(songOrWeek, diff);

		if (songScores.exists(formattedField))
		{
			if (songScores.get(formattedField) < score) setScore(formattedField, score);
		}
		else
			setScore(formattedField, score);
	}

	/**
		Set the score for `songOrWeek` to be `score`

		@param songOrWeek the song or week the scores being saved to
		@param score the score to save
	**/
	static function setScore(songOrWeek:String, score:Int):Void
	{
		if (songOrWeek.trim() == '') return;

		songScores.set(songOrWeek, score);

		Save.songScores.set(songScores);
		Save.flush();
	}

	/**
		Format `songOrWeek` to have the difficulty chart suffix of `diff`

		@param songOrWeek The target song or week
		@param diff The difficulty
	**/
	public static function formatToDifficulty(songOrWeek:String, diff:Difficulty):String
	{
		var daSong:String = songOrWeek;
		daSong += diff.chartSuffix();
		return daSong;
	}

	/**
		Receive the score of `songOrWeek` for difficulty `diff`

		@param songOrWeek The target song or week
		@param diff The difficulty
	**/
	public static function getScore(songOrWeek:String, diff:Difficulty):Int
	{
		if (!songScores.exists(formatToDifficulty(songOrWeek, diff))) setScore(formatToDifficulty(songOrWeek, diff), 0);

		return songScores.get(formatToDifficulty(songOrWeek, diff));
	}

	/**
		Receive the rank of `songOrWeek` for difficulty `diff`

		@param songOrWeek The target song or week
		@param diff The difficulty
	**/
	public static function getRank(songOrWeek:String, diff:Difficulty):Rank
	{
		if (!songRanks.exists(formatToDifficulty(songOrWeek, diff))) setScore(formatToDifficulty(songOrWeek, diff), 0);

		return songRanks.get(formatToDifficulty(songOrWeek, diff));
	}

	/**
		Load the song scores and ranks
		from the save data
	**/
	public static function load():Void
	{
		if (Save.songScores.get() != null) songScores = Save.songScores.get();
		if (Save.songRanks.get() != null) songRanks = Save.songRanks.get();
	}
}
