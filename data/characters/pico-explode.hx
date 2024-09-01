// Took the one inside the BaseGame source as a base  - Nex
import funkin.Constants;

function postCreate() {
	var game = GameOverSubstate.instance;
	new FlxTimer().start(3, function(_) {
		if(!game.isEnding) {
			var daSong = game?.gameOverSong;
			CoolUtil.playMusic(Paths.music(daSong), false, 1, true, Constants.DEFAULT_BPM);
			if(StringTools.endsWith(daSong, "explode") && FlxG.sound.music != null) {
				FlxG.sound.music.looped = false;
				FlxG.sound.music.onComplete = () -> {
					CoolUtil.playMusic(Paths.music("pico/gameOver"), false, 1, true, Constants.DEFAULT_BPM);
				}
			}
		}
	});
}

function onPlayAnim(event) {
	if(event.animName == "deathLoop" && getAnimName() == "deathLoop" && !isAnimFinished())
		event.cancelled = true;
}