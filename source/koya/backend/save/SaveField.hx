package koya.backend.save;

class SaveField<T>
{
	public var field:String = '';
	public var display:String = null;

	public function new(field:String, ?initalValue:T = null, ?display:String = null)
	{
		this.field = field;
		this.display = display;

		if (initalValue != null && get() == null) set(initalValue);
	}

	public function get():T
		return cast SaveFieldGetter.getField(field);

	public function set(value:T)
		SaveFieldGetter.setField(field, value);
}
