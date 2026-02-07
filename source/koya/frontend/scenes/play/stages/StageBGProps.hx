package koya.frontend.scenes.play.stages;

import flixel.graphics.frames.FlxAtlasFrames;
import koya.backend.play.stages.StageProp;
import flixel.FlxBasic;

class StageBGProps
{
	public static function parseProp(jsonFile:StageProp, propName:String, layer:StagePropLayerType,
			methods:{getImg:String->String, getSparrowImg:String->FlxAtlasFrames, getAtlasImg:String->FlxAtlasFrames}):FlxBasic
	{
		var propField:StageProp = cast Reflect.field(jsonFile, propName);

		if (propField == null) return null;
		if (propField.layerType != layer) return null;

		var propSprite:FunkinSprite = null;

		if (propField.sparrow != null)
		{
			propSprite = new FunkinSprite();
			propSprite.frames = methods.getSparrowImg(propField.sparrow);
		}

		if (propField.atlas != null)
		{
			propSprite = new FunkinSprite();
			propSprite.frames = methods.getAtlasImg(propField.atlas);
		}

		if (propField.img != null)
		{
			propSprite = new FunkinSprite();
			propSprite.loadGraphic(methods.getImg(propField.img));
		}

		if (propField.animations != null) for (anim in propField.animations)
		{
			if (anim.type == PREFIX && anim.prefix != null) propSprite.addPrefixAnim(anim.name, anim.prefix, anim?.fps ?? 24, anim?.looped ?? false);
			if (anim.type == FRAME_LABEL && anim.frame_label != null) propSprite.addFrameLabelAnim(anim.name, anim.frame_label, anim?.fps ?? 24,
				anim?.looped ?? false);
		}

		if (propField == null) return null;

		if (propField.layer != null) propSprite.ID = propField.layer;

		if (propField.position != null)
		{
			propSprite.x = propField.position[0];
			propSprite.y = propField.position[1];
		}

		if (propField.scrollFactor != null)
		{
			propSprite.scrollFactor.x = propField.scrollFactor[0];
			propSprite.scrollFactor.y = propField.scrollFactor[1];
		}

		if (propField.scale != null)
		{
			propSprite.scale.x = propField.scale[0];
			propSprite.scale.y = propField.scale[1];
		}

		return propSprite;
	}
}
