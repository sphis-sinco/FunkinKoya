package koya.frontend.scenes.menustates.options;

class ConfirmPrompt extends Prompt
{
	override public function new(?additionalInfo:String, ?leaveMethod:Void->Void)
	{
		super(leaveMethod);

		this.prompt = 'Are you sure about this?${additionalInfo ?? ''}';
	}

	override function handleControls()
	{
		super.handleControls();

		if (controls.ACCEPT) accept();
	}
}
