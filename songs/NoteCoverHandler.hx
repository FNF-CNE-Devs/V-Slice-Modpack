import flixel.group.FlxTypedSpriteGroup;

import notes.NoteHoldCover;
import notes.NoteHoldSplash;

/*
 * Most of these variables are recommended to be set in function onStrumCreation for it to be set correctly.
*/


/*
 * Group of the note hold covers.
*/
public var coverSplashGroup:FlxTypedSpriteGroup = new FlxTypedSpriteGroup();

/*
 * Array of the opponent's note hold covers.
*/
public var opponentHoldGroup:Array<NoteHoldCover> = [];

/*
 * Array of the player's note hold covers.
*/
public var playerHoldGroup:Array<NoteHoldCover> = [];

/*
 * Strumline for the opponent's note hold covers.
*/
public var opponentStrumline:Int = PlayState.instance.opponentMode ? 1 : 0;

/*
 * Strumline for the player's note hold covers.
*/
public var playerStrumline:Int = PlayState.instance.opponentMode ? 0 : 1;

/*
 * Hides the note hold covers if set to true. (Will disable this script entirely)
*/
public var hideHoldCovers:Bool = false;

/*
 * Positions for each cover.
*/
public var coverX:Float = -107.5;
public var coverY:Array<Float> = [-100, -195]; // Upscroll, Downscroll

if (hideHoldCovers) disableScript();

function onPostStrumCreation(e)
{
    coverSplashGroup.cameras = [camHUD];
    add(coverSplashGroup);

    for (i in 0...8)
    {
        var cover = new NoteHoldCover(i, downscroll);
        cover.posX = coverX;
        cover.posY = coverY;

        if (i <= 3) playerHoldGroup.push(cover);
        else opponentHoldGroup.push(cover);

        coverSplashGroup.add(cover);
    }

    add(opponentHoldGroup);
    add(playerHoldGroup);
}

function update(elapsed:Float){
    for (lol in 0...4)
    {
        var playerStrum = strumLines.members[playerStrumline].members[lol];
        playerHoldGroup[lol].updatePosition(playerStrum);

        var opponentStrum = strumLines.members[opponentStrumline].members[lol];
        opponentHoldGroup[lol].updatePosition(opponentStrum);
    }
}

function onDadHit(e)
    if (!e.cancelled && e.note.isSustainNote && e.note.__strum != null){
        opponentHoldGroup[e.direction].start();

        if (e.note.animation.name == "holdend")
            coverSpark(e.direction, e.note.height / 3.5, true);
    }

function onPlayerHit(e)
    if (!e.cancelled && e.note.isSustainNote && e.note.__strum != null){
        playerHoldGroup[e.direction].start();

        if (e.note.animation.name == "holdend")
            coverSpark(e.direction, e.note.height / 3.5, false);
    }

function onPlayerMiss(e)
    if (playerHoldGroup[e.direction].visible)
        coverSpark(e.direction, null);

function coverSpark(susInt:Int, delay:Float, isDad:Bool) {
    var cover = isDad ? opponentHoldGroup[susInt] : playerHoldGroup[susInt];

    new FlxTimer().start(0.01 * delay, function(){
        if (!isDad)
        {
            var strum = strumLines.members[playerStrumline].members[susInt];
    
            var x = cover.x = strum.x + cover.posX;
            var y = cover.y = downscroll ? strum.y + cover.posY[1] : strum.y + cover.posY[0];
            var angle = cover.angle = strum.angle;
        
            var splash = new NoteHoldSplash(susInt);
            splash.setPosition(x, y);
            splash.angle = angle;
            splash.antialiasing = cover.antialiasing;
            splash.visible = cover.visible;
            coverSplashGroup.add(splash);
        }

        cover.visible = false;
    });
}