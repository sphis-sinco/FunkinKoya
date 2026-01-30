package frontend;

import backend.AssetPaths;
import animate.FlxAnimate;

class FunkinSprite extends FlxAnimate
{
	public function parseAnimationOffsetFile(offsetFile:Array<String>)
	{
		for (line in offsetFile)
		{
			var splitLine = line.split(' ');

			var anim = splitLine[0] ?? null;
			var x = splitLine[1] ?? '0';
			var y = splitLine[2] ?? '0';

			if (anim != null)
				addOffset(anim, Std.parseFloat(x), Std.parseFloat(y));
		}
	}

	public var animOffsets:Map<String, Array<Float>> = [];
	public var generalOffsets:Array<Float> = [0, 0];

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		anim.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(anim.name);
		if (animOffsets.exists(anim.name))
			offset.set(daOffset[0] + (generalOffsets[0] ?? 0), daOffset[1] + (generalOffsets[1] ?? 0));
		else
			offset.set(0 + (generalOffsets[0] ?? 0), 0 + (generalOffsets[1] ?? 0));
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
		animOffsets[name] = [x, y];

	public function addPrefixAnim(name:String, prefix:String, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByPrefix(name, prefix, fps, looped);

	public function addFrameLabelAnim(name:String, label:String, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByFrameLabel(name, label, fps, looped);

	public function addIndicesPrefixAnim(name:String, prefix:String, indices:Array<Int>, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByIndices(name, prefix, indices, '', fps, looped);

	public function addIndicesFrameLabelAnim(name:String, label:String, indices:Array<Int>, ?fps:Float = 24, ?looped:Bool = false)
		anim.addByFrameLabelIndices(name, label, indices, fps, looped);
}
