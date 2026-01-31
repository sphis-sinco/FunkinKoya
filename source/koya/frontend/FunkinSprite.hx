package koya.frontend;

import flixel.FlxG;
import koya.backend.AssetPaths;
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

			if (anim != null) addOffset(anim, Std.parseFloat(x), Std.parseFloat(y));
		}
	}

	public var animOffsets:Map<String, Array<Float>> = [];
	public var generalOffsets:Array<Float> = [0, 0];
	public var cameraOffsets:Array<Float> = [0, 0];

	/**
	 * Whether or not this sprite has an animation with the given ID.
	 * @param id The ID of the animation to check.
	 */
	public function hasAnimation(id:String):Bool
	{
		var animationList:Array<String> = this.anim?.getNameList() ?? [];

		if (animationList.contains(id)) return true;

		return false;
	}

	/**
	 * Ensure that a given animation exists before playing it.
	 * Will gracefully check for name, then name with stripped suffixes, then fail to play.
	 * @param name The animation name to attempt to correct.
	 * @param fallback Instead of failing to play, try to play this animation instead.
	 */
	function correctAnimationName(name:String, ?fallback:String):String
	{
		// If the animation exists, we're good.
		if (hasAnimation(name)) return name;

		// Attempt to strip a `-alt` suffix, if it exists.
		if (name.lastIndexOf('-') != -1)
		{
			var correctName = name.substring(0, name.lastIndexOf('-'));
			FlxG.log.notice('Sprite tried to play animation "$name" that does not exist, stripping suffixes ($correctName)...');
			return correctAnimationName(correctName);
		}
		else
		{
			if (fallback != null)
			{
				if (fallback == name)
				{
					FlxG.log.error('Sprite tried to play animation "$name" that does not exist! This is bad!');
					return name;
				}
				else
				{
					FlxG.log.warn('Sprite tried to play animation "$name" that does not exist, fallback to idle...');
					return correctAnimationName('idle');
				}
			}
			else
			{
				FlxG.log.error('Sprite tried to play animation "$name" that does not exist! This is bad!');
				return null;
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		anim.play(correctAnimationName(AnimName), Force, Reversed, Frame);

		var daOffset = animOffsets.get(anim.name);
		if (animOffsets.exists(anim.name)) offset.set(daOffset[0] + (generalOffsets[0] ?? 0), daOffset[1] + (generalOffsets[1] ?? 0));
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
