package backend.save;

import flixel.FlxG;

class SaveFieldGetter
{
	public static function getField(field:String):Dynamic
	{
		if (!FlxG.save.isBound || FlxG.save.isEmpty()) return null;

		return Reflect.getProperty(FlxG.save.data, field);
	}

	public static function setField(field:String, value:Dynamic)
	{
		if (FlxG.save.isBound) Reflect.setProperty(FlxG.save.data, field, value);
	}
}
