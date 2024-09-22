public var lightningStrike:Bool = true;
public var lightningStrikeBeat:Int = 0;
public var lightningOffset:Int = 8;
public var thunderSFXamount:Int = 2;

function onPostStageCreation(_) for (strum in PlayState.SONG.strumLines) {
	var copy = strum?.characters.copy();
	for (char in copy) {
		var dark = char + "-dark";
		if (Assets.exists(Paths.xml("characters/" + dark)))
			strum.characters.insert(strum.characters.indexOf(char) + 1, dark);
	}
}

function create() {
	for(i in 1...thunderSFXamount+1)
		FlxG.sound.load(Paths.sound('thunder_' + Std.string(i)));

	for (strum in PlayState.SONG.strumLines) {
		var copy = strum?.characters.copy();
		for (char in copy) if (StringTools.endsWith(char, "-dark"))
			strum.characters.remove(char);
	}
}

function postCreate() if (rainShader != null) {
	camGame.removeShader(rainShader);
	trees.shader = rainShader;
}

function onPlayerMiss(event)
	event.gfSadAnim = false;

function lightningStrikeShit():Void
{
	FlxG.sound.play(Paths.soundRandom('thunder_', 1, thunderSFXamount));

	// TODO: Apply dark characters to this
    for (bg in [bgLight, stairsLight])
	{
		bg.alpha = 1;

		new FlxTimer().start(0.06, function(_) {
			bg.alpha = 0;
		});

		new FlxTimer().start(0.12, function(_) {
			bg.alpha = 1;
			FlxTween.tween(bg, {alpha: 0}, 1.5);
		});
	}

	lightningStrikeBeat = curBeat;
	lightningOffset = FlxG.random.int(8, 24);

	strumLines.forEachAlive(function(strum) for (char in strum.characters) {
		char.playAnim('scared', true, "SING"); // SING so that they dont get indefinitely looped
		if (StringTools.endsWith(char.curCharacter, "-dark")) {
			char.alpha = 0;

			new FlxTimer().start(0.06, function(_) {
				char.alpha = 1;
			});

			new FlxTimer().start(0.12, function(_) {
				char.alpha = 0;
				FlxTween.tween(char, {alpha: 1}, 1.5);
			});
		}
	});
}

function beatHit(curBeat)
	if (lightningStrike && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		lightningStrikeShit();