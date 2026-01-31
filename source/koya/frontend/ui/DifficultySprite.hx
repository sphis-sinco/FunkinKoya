package koya.frontend.ui;

import koya.backend.play.Difficulty;
import koya.backend.AssetPaths;

class DifficultySprite extends FunkinSprite
{
	public var difficulty(default, set):Difficulty;

	function set_difficulty(diff:Difficulty):Difficulty
	{
		loadGraphic(AssetPaths.image('difficulties/${diff.toString()}', 'ui'));

		return diff;
	}

	override public function new(difficulty:Difficulty, ?X:Float, ?y:Float)
	{
		super(x, y);

		this.difficulty = difficulty;
	}
}
