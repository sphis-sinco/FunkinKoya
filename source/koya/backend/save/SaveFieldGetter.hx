package koya.backend.save;

import flixel.FlxG;

class SaveFieldGetter
{
	/**
		Get `field` from Save data

		@param field save field
	**/
	public static function getField(field:String):Dynamic
	{
		if (!FlxG.save.isBound || FlxG.save.isEmpty()) return null;

		return Reflect.getProperty(FlxG.save.data, field);
	}

	/**
		Set `field` of Save data to `value`

		@param field save field
		@param value save field new value
	**/
	public static function setField(field:String, value:Dynamic)
	{
		if (FlxG.save.isBound) Reflect.setProperty(FlxG.save.data, field, value);
	}
}
