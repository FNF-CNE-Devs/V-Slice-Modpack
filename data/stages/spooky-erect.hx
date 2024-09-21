public var lightningStrike:Bool = true;
public var lightningStrikeBeat:Int = 0;
public var lightningOffset:Int = 8;
public var thunderSFXamount:Int = 2;

// TODO: When the rain shader is fully implemented, add the rain shader to the trees sprite.

function create()
	for(i in 1...thunderSFXamount+1)
		FlxG.sound.load(Paths.sound('thunder_' + Std.string(i)));

public function lightningStrikeShit():Void
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

	boyfriend.playAnim('scared', true, "SING"); // SING so that they dont get indefinitely looped
	gf.playAnim('scared', true, "SING");
}

function beatHit(curBeat) {
	if (lightningStrike && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
	{
		lightningStrikeShit();
	}
}