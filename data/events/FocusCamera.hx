import flixel.camera.FlxCameraFollowStyle;
import funkin.backend.utils.native.HiddenProcess;

var offsetCamX:Int = 0;
var offsetCamY:Int = 0;
var durationForTween:Int = 4;
var easeTweenType:String;

var BGTween:Bool = false;
var LockOn:Bool = false;

var chartingMode:Bool = false;
var allowFocusVisual:Bool = false;

function create(){
    if(PlayState.chartingMode){
        focusCameraVisual = new FlxSprite();
        focusCameraVisual.makeGraphic(10, 10, 0xffffffff);
        focusCameraVisual.alpha = 0;
        focusCameraVisual.updateHitbox();
        add(focusCameraVisual);
        trace("\n                Welcome to Charting/DebugMode!\n      Press [SPACE] to toggle camFollow positions ON/OFF\n       (NOTE: this is only available via ChartingMenu.)");
    }
    camFollowTween = FlxTween.tween(camFollow, {x: camFollow.x, y: camFollow.y}, 0.001);
}

function onEvent(_) {
	switch (_.event.name){
		case 'FocusCamera':
            durationForTween = _.event.params[3];
            easeTweenType = _.event.params[4];
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

            switch(easeTweenType.toUpperCase()){
                case "CLASSIC":
                    LockOn = false;
                    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
                default:
                    LockOn = true;
                    FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 1);
            }
            if(camFollowTween != null) camFollowTween.cancel();
        case "Camera Movement":
            offsetCamX = 0;
            offsetCamY = 0;
            BGTween = false;
            if(LockOn){
                LockOn = false;
                FlxG.camera.follow(camFollow, FlxCameraFollowStyle.LOCKON, 0.04);
            }
            if(camFollowTween != null) camFollowTween.cancel();
    }
}

function update(){
    if(PlayState.chartingMode){
        focusCameraVisual.setPosition(camFollow.x, camFollow.y);
        if(FlxG.keys.justPressed.SPACE){
            if(allowFocusVisual){
                allowFocusVisual = false;
            }else if(!allowFocusVisual){
                allowFocusVisual = true;
            }
        }
        switch(allowFocusVisual){
            case false: focusCameraVisual.alpha = 0;
            case true: focusCameraVisual.alpha = 1;
        }
    }

    var pos = FlxPoint.get();
	var r = 0;
	for(c in strumLines.members[curCameraTarget].characters) {
		var cpos = c.getCameraPosition();
		pos.x += cpos.x;
		pos.y += cpos.y;
		r++;
	}
	if (r > 0) {
		pos.x /= r;
		pos.y /= r;					
	}

	if (BGTween){
        switch(easeTweenType.toUpperCase()){
            case "CLASSIC" | "INSTANT": camFollowOffsetsFunction(pos);
            default: camFollowTweenFunction(pos);
        } 
    }
}

function camFollowTweenFunction(pos){
    camFollowTween = FlxTween.tween(camFollow, {x: pos.x + offsetCamX, y: pos.y + offsetCamY}, (Conductor.stepCrochet / 1000) * durationForTween, {ease: Reflect.field(FlxEase, easeTweenType)});
}

function camFollowOffsetsFunction(pos){
    camFollow.setPosition(pos.x + offsetCamX, pos.y + offsetCamY);
}

function onCameraMove(event){
    switch(BGTween){
        case true: event.cancelled = true;
        case false: event.cancelled = false;
    } 
}