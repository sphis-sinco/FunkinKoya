package koya.backend.play;

import koya.frontend.FunkinSprite;
import koya.backend.play.ObjectData;

class ObjectManager
{
	/**
		Add `animations` to `sprite`

		@param sprite Sprite you want to add the animations to
		@param animations array of animations
	**/
	public static function addObjectAnimationsToSprite(sprite:FunkinSprite, animations:Array<ObjectAnimationData>)
	{
		for (anim in animations)
		{
			if (anim.type == PREFIX && anim.prefix != null) sprite.addPrefixAnim(anim.name, anim.prefix, anim?.fps ?? 24, anim?.looped ?? false);

			if (anim.type == FRAME_LABEL && anim.frame_label != null) sprite.addFrameLabelAnim(anim.name, anim.frame_label, anim?.fps ?? 24,
				anim?.looped ?? false);
		}
	}
}
