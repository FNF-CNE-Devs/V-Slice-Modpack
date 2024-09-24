var tweenedZoomPLEASEWORK:Bool = false;
function create() zoomTween = FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.1); // just used so zoomTween.cancel() can work
function onEvent(_) {
    if (_.event.name == 'Cam Zoom') {
        if (_.event.params[1] == null && _.event.params[2] == null){
            defaultCamZoom = _.event.params[0];
        } else {
            var tweenType = _.event.params[2];

            if(zoomTween != null) zoomTween.cancel();

            switch(tweenType){
                case "INSTANT":
                    zoomTween = FlxTween.tween(FlxG.camera, {zoom: _.event.params[0]}, 0.00000000001, {onComplete: function(value) {
                        defaultCamZoom = FlxG.camera.zoom;
                    }});
                default:
                    tweenedZoomPLEASEWORK = true;
                    zoomTween = FlxTween.tween(FlxG.camera, {zoom: _.event.params[0]}, (Conductor.stepCrochet / 1000) * _.event.params[1], {ease: Reflect.field(FlxEase, tweenType), onComplete: function(value) {
                        defaultCamZoom = FlxG.camera.zoom;
                        tweenedZoomPLEASEWORK = false;
                    }});
            }
        }
    }
}

/*function update(){
    if(tweenedZoomPLEASEWORK){
        if(camZooming){
            camZoomingStrength = lerp(1.0, camZoomingStrength, 0.05); // Lerp bop multiplier back to 1.0x
            var zoomPlusBop = FlxG.camera.zoom * camZoomingStrength; // Apply camera bop multiplier.
            FlxG.camera.zoom = zoomPlusBop;
        }
    }
}
    
function beatHit(curBeat){
    if(Options.camZoomOnBeat && camZooming && FlxG.camera.zoom < maxCamZoom && curBeat % camZoomingInterval == 0){
        if(tweenedZoomPLEASEWORK){
            FlxG.camera.zoom += 0.015 * camZoomingStrength;
        }
    }
}*/