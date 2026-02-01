package koya.backend.save;

class SaveField<T>
{
	public var field:String = '';

	public function new(field:String, ?initalValue:T = null)
	{
		this.field = field;

		if (initalValue != null && get() == null) set(initalValue);
	}

	public function get():T
		return cast SaveFieldGetter.getField(field);

	public function set(value:T)
		SaveFieldGetter.setField(field, value);
}
