package koya.backend.macros;

#if !display
/**
	Yoinked from Funkin (0.8.1)

	This provides git stuffs
**/
class Git
{
	public static macro function gimmeSuffix():haxe.macro.Expr.ExprOf<String>
	{
		#if !display
		// Get the current line number.
		var pos = haxe.macro.Context.currentPos();

		var process = new sys.io.Process('git', ['rev-parse', 'HEAD']);
		if (process.exitCode() != 0)
		{
			var message = process.stderr.readAll().toString();
			haxe.macro.Context.warning('Could not determine current git commit; is this a proper Git repository?', pos);
		}

		// read the output of the process
		var commitHash:String = process.stdout.readLine();
		var commitHashSplice:String = commitHash.substr(0, 7);

		process.close();

		// Generates a string expression
		var branchProcess = new sys.io.Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);

		if (branchProcess.exitCode() != 0)
		{
			var message = branchProcess.stderr.readAll().toString();
			haxe.macro.Context.warning('Could not determine current git commit; is this a proper Git repository?', pos);
		}

		var branchName:String = branchProcess.stdout.readLine();
		branchProcess.close();

		var val = '$branchName:$commitHashSplice';

		// Generates a string expression
		haxe.macro.Context.info('Git: ${val}', pos);
		return macro $v{val};
		#else
		// `#if display` is used for code completion. In this case returning an
		// empty string is good enough; We don't want to call git on every hint.
		var mt:String = "";
		return macro $v{mt};
		#end
	}
}
#end
