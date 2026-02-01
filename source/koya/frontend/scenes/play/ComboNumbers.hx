package koya.frontend.scenes.play;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import koya.backend.Conductor;
import koya.backend.AssetPaths;
import flixel.group.FlxGroup.FlxTypedGroup;

class ComboNumbers extends FlxTypedGroup<FunkinSprite>
{
	public var onComplete:ComboNumbers->Void = null;

	public var comboLength:Int = 0;

	override public function new(combo:Int, startingX:Float = 0, ?onComplete:ComboNumbers->Void)
	{
		super();

		this.onComplete = onComplete;

		var seperatedScore:Array<Int> = [];
		if (combo < 1) seperatedScore = [0];
		else
		{
			var tempCombo:Int = Std.int(Math.abs(combo));

			while (tempCombo != 0)
			{
				seperatedScore.push(tempCombo % 10);
				tempCombo = Std.int(tempCombo / 10);
			}

			while (seperatedScore.length < 1)
				seperatedScore.push(0);
		}

		seperatedScore.reverse();

		this.comboLength = seperatedScore.length;

		var daLoop:Int = 0;
		FlxG.log.add(seperatedScore);
		for (i in seperatedScore)
		{
			var numScore:FunkinSprite = new FunkinSprite();
			numScore.loadGraphic(AssetPaths.image('num${Std.int(i)}'));
			numScore.screenCenter();
			numScore.x = startingX + (43 * daLoop) - 90;
			numScore.y += 80;
			numScore.ID = daLoop;

			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2,
				{
					onComplete: function(tween:FlxTween) {
						numScoreDied(numScore.ID);
						comboLength--;

						numScore.destroy();
						remove(numScore);
					},
					startDelay: Conductor.crochet * 0.002
				});

			daLoop++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (comboLength == 0)
		{
			comboLength--;
			if (onComplete != null) onComplete(this);
		}
	}

	public dynamic function numScoreDied(id:Int) {}
}
