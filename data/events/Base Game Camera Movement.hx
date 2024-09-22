var offsetCamX:Int = 0;
var offsetCamY:Int = 0;
var durationForTween:Int = 4;
var easeTweenType:String;

var BGTween:Bool = false;
var LockOn:Bool = false;

import funkin.backend.scripting.events.CamMoveEvent;
import funkin.backend.scripting.EventManager;
import flixel.camera.FlxCameraFollowStyle;

function onEvent(_) {
	switch (_.event.name){
		case 'Base Game Camera Movement':
            curCameraTarget = _.event.params[0];

            BGTween = true;

            if(_.event.params[1] != null || _.event.params[1] != ""){
                offsetCamX = _.event.params[1];
            } else {
                offsetCamX = 0;
            }
            if(_.event.params[2] != null || _.event.params[2] != ""){
                offsetCamY = _.event.params[2];
            } else {
                offsetCamY = 0;
            }

            switch(easeTweenType){
                case "INSTANT":
                    LockOn = true;
                    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 1);
                default:
                    LockOn = false;
                    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
            }
            durationForTween = _.event.params[3];
            easeTweenType = _.event.params[4];
            
        case "Camera Movement":
            offsetCamX = 0;
            offsetCamY = 0;
            BGTween = false;
            if(LockOn){
                LockOn = false;
                FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
            }
    }
}

function update(){
    var posL = FlxPoint.get();
	var rL = 0;
	for(cL in strumLines.members[curCameraTarget].characters) {
		var cposL = cL.getCameraPosition();
		posL.x += cposL.x;
		posL.y += cposL.y;
		rL++;
	}
	if (rL > 0) {
		posL.x /= rL;
		posL.y /= rL;					
	}
    
	var event = scripts.event("onCameraMove", EventManager.get(CamMoveEvent).recycle(posL, strumLines.members[curCameraTarget], rL));
	if (event.cancelled){
        switch(easeTweenType){
            case "CLASSIC" | "INSTANT":
                camFollowOffsets(posL);
            default:
                camFollowTween(posL);
        }
            
    }
}

function camFollowTween(posL) camFollowTween = FlxTween.tween(camFollow, {x: posL.x + offsetCamX, y: posL.y + offsetCamY}, (Conductor.stepCrochet / 1000) * durationForTween, {ease: Reflect.field(FlxEase, easeTweenType)});

function camFollowOffsets(posL) camFollow.setPosition(posL.x + offsetCamX, posL.y + offsetCamY);

function onCameraMove(event){
    if(BGTween){
        event.cancelled = true;
    } else {
        event.cancelled = false;
    } 
}