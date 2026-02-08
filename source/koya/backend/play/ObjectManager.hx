package koya.backend.play;

import koya.frontend.FunkinSprite;
import koya.backend.play.ObjectData;

class ObjectManager
{
	public static function addObjectAnimationsToSprite(spr:FunkinSprite, animations:Array<ObjectAnimationData>)
	{
		for (anim in animations)
		{
			if (anim.type == PREFIX && anim.prefix != null)
			{
				spr.addPrefixAnim(anim.name, anim.prefix, anim?.fps ?? 24, anim?.looped ?? false);
			}

			if (anim.type == FRAME_LABEL && anim.frame_label != null)
			{
				spr.addFrameLabelAnim(anim.name, anim.frame_label, anim?.fps ?? 24, anim?.looped ?? false);
			}
		}
	}
}
