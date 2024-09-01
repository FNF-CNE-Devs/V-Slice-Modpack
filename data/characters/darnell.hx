// Took the one inside the BaseGame source as a base  - Nex

// TO FINISH the can stuff once FlxAnimate gets updated (pls neeoooooo)  - Nex
var canSprite:FunkinSprite = null;

function onNoteHit(event)
{
	if (event.character == this) {
		// Override the hit note animation.
		switch(event.noteType) {
			case "lightcan":
				event.animCancelled = true;
				playLightCanAnim();
			case "kickcan":
				event.animCancelled = true;
				playKickCanAnim();
			case "kneecan":
				event.animCancelled = true;
				playKneeCanAnim();
		}
	}
}

function gamePostCreate() {
	// Precaching  - Nex
	var arr = PlayState.instance.SONG.noteTypes;
	if(arr.contains("lightcan")) FlxG.sound.load(Paths.sound('pico/Darnell_Lighter'));
	if(arr.contains("kickcan")) FlxG.sound.load(Paths.sound('pico/Kick_Can_UP'));
	if(arr.contains("kneecan")) {
		loadCanSprite();
		FlxG.sound.load(Paths.sound('pico/Kick_Can_FORWARD'));
	}
}

function loadCanSprite() {
	canSprite?.destroy();
	canSprite = new FunkinSprite(0, 0, Paths.image("characters/spraycanAtlas"));
}

/*function onNoteIncoming(event:NoteScriptEvent) {
	if (!event.note.noteData.getMustHitNote() && characterType == CharacterType.DAD) {
		// Get how long until it's time to strum the note.
		var msTilStrum = event.note.strumTime - Conductor.instance.songPosition;

		switch(event.note.kind) {
			case "weekend-1-lightcan":
				scheduleLightCanSound(msTilStrum - 65);
			case "weekend-1-kickcan":
				scheduleKickCanSound(msTilStrum - 50);
			case "weekend-1-kneecan":
				scheduleKneeCanSound(msTilStrum - 22);
			default:
				super.onNoteIncoming(event);
		}
	}
}*/

/**
 * Play the animation where Darnell kneels down to light the can.
 */
function playLightCanAnim() {
	this.playAnim('lightCan', true, "LOCK");
	FlxG.sound.play(Paths.sound('pico/Darnell_Lighter'));
}

// var lightCanSound:FunkinSound;
// var loadedLightCanSound:Bool = false;
/**
 * Schedule the can-lighting sound to play in X ms
 */
/*function scheduleLightCanSound(timeToPlay:Float) {
	if (!loadedLightCanSound) {
		lightCanSound = FunkinSound.load(Paths.sound('Darnell_Lighter'), 1.0);
		loadedLightCanSound = true;
	}

	lightCanSound.play(true, -timeToPlay);
}*/

/**
 * Play the animation where Darnell kicks the can into the air.
 */
function playKickCanAnim() {
	this.playAnim('kickCan', true);
	FlxG.sound.play(Paths.sound('pico/Kick_Can_UP'));

	if(canSprite == null) loadCanSprite();
}

// var kickCanSound:FunkinSound;
// var loadedKickCanSound:Bool = false;
/**
 * Schedule the can-kicking sound to play in X ms
 */
/*function scheduleKickCanSound(timeToPlay:Float) {
	if (!loadedKickCanSound) {
		kickCanSound = FunkinSound.load(Paths.sound('Kick_Can_UP'), 1.0);
		loadedKickCanSound = true;
	}

	kickCanSound.play(true, -timeToPlay);
}*/

/**
 * Play the animation where Darnell knees the can in Pico's direction.
 */
function playKneeCanAnim() {
	this.playAnim('kneeCan', true);
	FlxG.sound.play(Paths.sound('pico/Kick_Can_FORWARD'));

	if(canSprite == null) loadCanSprite();
}

// var kneeCanSound:FunkinSound;
// var loadedKneeCanSound:Bool = false;
/**
 * Schedule the can-kneeing sound to play in X ms
 */
/*function scheduleKneeCanSound(timeToPlay:Float) {
	if (!loadedKneeCanSound) {
		kneeCanSound = FunkinSound.load(Paths.sound('Kick_Can_FORWARD'), 1.0);
		loadedKneeCanSound = true;
	}

	kneeCanSound.play(true, -timeToPlay);
}*/
