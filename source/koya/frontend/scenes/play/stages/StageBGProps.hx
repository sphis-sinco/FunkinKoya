package koya.frontend.scenes.play.stages;

import koya.backend.play.ObjectManager;
import animate.FlxAnimateFrames;
import flixel.graphics.frames.FlxAtlasFrames;
import koya.backend.play.stages.StageProp;
import flixel.FlxBasic;

class StageBGProps
{
	/**
		@param propField Stage Prop Data
		@param methods JSON of methods
	**/
	public static function parseProp(propField:StageProp,
			methods:{getImg:String->String, getSparrowImg:String->FlxAtlasFrames, getAtlasImg:String->FlxAnimateFrames}):FlxBasic
	{
		if (propField == null) return null;

		var propSprite:FunkinSprite = new FunkinSprite();

		var loadSparrow = function() {
			propSprite.frames = methods?.getSparrowImg(propField.sparrow) ?? null;
		}

		var loadAtlas = function() {
			propSprite.frames = methods?.getAtlasImg(propField.sparrow) ?? null;
		}

		var loadImg = function() {
			if (methods.getImg != null) propSprite.loadGraphic(methods.getImg(propField.img));
		}

		if (propField.sparrow != null) loadSparrow();
		if (propField.atlas != null) loadAtlas();
		if (propField.img != null) loadImg();

		if (propField.animations != null) ObjectManager.addObjectAnimationsToSprite(propSprite, propField.animations);

		if (propSprite.graphic == null) return null;

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
			if (propField.scaleUpdateHitbox) propSprite.updateHitbox();
		}

		propSprite.alpha = propField.alpha ?? 1.0;

		return propSprite;
	}
}
