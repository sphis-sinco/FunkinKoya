package koya.frontend.scenes.play.scenes;

import koya.backend.songs.Song;
import lime.utils.Assets;
import koya.backend.Highscore;
import koya.backend.play.Difficulty;
import koya.frontend.scenes.play.songs.SongClass;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import koya.frontend.ui.Alphabet;
import koya.frontend.scenes.freeplay.FreeplayState;
import koya.backend.AssetPaths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

using StringTools;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['resume', 'restart song'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var topText:FlxTypedGroup<FlxText>;
	var topTexts:Array<String> = [
		'PAUSED',
		null,
		'Song: ${PlayState.SONG.song}',
		'Song Composer(s): ${PlayState.SONG?.authors ?? 'Unknown'}',
		'Song Difficulty: ${PlayState.SONG?.difficulty}'
	];

	public function new(x:Float, y:Float)
	{
		super();

		for (difficulty in Difficulty.list)
		{
			if (PlayState.SONG_DIFFICULTY == difficulty) continue;

			var song = PlayState.SONG.song.toLowerCase();
			var chart = Highscore.formatSong(song, difficulty);

			if (Assets.exists(AssetPaths.chart(song, chart))) menuItems.push('change to ${difficulty.toString()}');
		}

		menuItems.push('exit to menu');

		pauseMusic = new FlxSound().loadEmbedded(AssetPaths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		topText = new FlxTypedGroup<FlxText>();
		add(topText);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		var delat:Float = 0.3;

		var fieldY = 5;

		for (field in topTexts)
		{
			if (field != null)
			{
				var newTopText = new FlxText(10, fieldY - 5, FlxG.width - 20, field, 32);
				newTopText.scrollFactor.set();
				newTopText.setFormat(AssetPaths.font('vcr.ttf'), 32);
				newTopText.updateHitbox();
				newTopText.antialiasing = false;
				newTopText.alignment = RIGHT;
				topText.add(newTopText);
				newTopText.alpha = 0;
				FlxTween.tween(newTopText, {alpha: 1, y: fieldY}, 0.4, {ease: FlxEase.quartInOut, startDelay: delat});
			}

			delat += .2;
			fieldY += 32;
		}

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		FlxG.camera.followLerp = 0;
		PlayState.instance.tweenManager.active = false;
		PlayState.instance.songScript.pause();
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5) pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP) changeSelection(-1);
		if (downP) changeSelection(1);

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			FlxG.camera.followLerp = PlayState.CAMFOLLOWLERP;
			switch (daSelected.toLowerCase())
			{
				case "resume":
					PlayState.instance.tweenManager.active = true;
					close();
				case "restart song":
					FlxG.switchState(() -> new PlayState());
				case "exit to menu":
					if (PlayState.IS_STORYMODE) FlxG.switchState(() -> new StoryModeState());
					else
						FlxG.switchState(() -> new FreeplayState());
			}

			if (daSelected.toLowerCase().startsWith('change to '))
			{
				var difficulty:String = '';

				var i = 0;
				for (e in daSelected.split(' '))
				{
					if (i > 1) difficulty += '$e ';

					i++;
				}

				difficulty = difficulty.toLowerCase().trim();

				var song = PlayState.SONG.song.toLowerCase();
				var chart = Highscore.formatSong(song, Difficulty.stringList.indexOf(difficulty));

				PlayState.loadSong(chart, song, Difficulty.stringList.indexOf(difficulty));
				FlxG.switchState(() -> new PlayState());
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0) curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length) curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0) item.alpha = 1;
		}
	}
}
