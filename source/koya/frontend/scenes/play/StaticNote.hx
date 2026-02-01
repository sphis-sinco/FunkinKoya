package koya.frontend.scenes.play;

import koya.backend.AssetPaths;

class StaticNote extends FunkinSprite
{
	override public function new(i:Int, ?x:Float, ?y:Float)
	{
		super(x, y);

		frames = AssetPaths.fromSparrow('NOTE_assets');
		animation.addByPrefix('green', 'arrowUP');
		animation.addByPrefix('blue', 'arrowDOWN');
		animation.addByPrefix('purple', 'arrowLEFT');
		animation.addByPrefix('red', 'arrowRIGHT');

		setGraphicSize(Std.int(width * 0.7));

		var dir = '';

		switch (Math.abs(i))
		{
			case 0:
				dir = 'left';
			case 1:
				dir = 'down';
			case 2:
				dir = 'up';
			case 3:
				dir = 'right';
		}

		addPrefixAnim('static', 'arrow${dir.toUpperCase()}', 24, true);
		addPrefixAnim('pressed', '${dir.toLowerCase()} press');
		addPrefixAnim('confirm', '${dir.toLowerCase()} confirm');

		playAnim('confirm');
		centerOffsets();
		addOffset('confirm', offset.x - 13, offset.y - 13);

		var noRealOffsetOffset = ['static', 'pressed'];

		for (anim in noRealOffsetOffset)
		{
			playAnim(anim);
			centerOffsets();
			addOffset(anim, offset.x, offset.y);
		}

		this.ID = i;
		playAnim('static');
		this.x += Note.swagWidth * i;
	}

	override function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		super.playAnim(AnimName, Force, Reversed, Frame);
	}
}
