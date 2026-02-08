package koya.backend.save;

class SaveField<T>
{
	/** Save Field name **/
	public var field:String = '';

	/** Display name **/
	public var display:String = null;

	/**
		Initalize Save Field class

		@param field Field name
		@param initalValue Inital value if the save field is null
		@param display Display Name
	**/
	public function new(field:String, ?initalValue:T = null, ?display:String = null)
	{
		this.field = field;
		this.display = display;

		if (initalValue != null && get() == null) set(initalValue);
	}

	/** Get save field value **/
	public function get():T
		return cast SaveFieldGetter.getField(field);

	/** Set save field value **/
	public function set(value:T)
		SaveFieldGetter.setField(field, value);
}
