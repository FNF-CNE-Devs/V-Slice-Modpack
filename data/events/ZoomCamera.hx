function create() zoomTween = FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.1); // just used so zoomTween.cancel() can work
function onEvent(_) {
    if (_.event.name == 'ZoomCamera') {
        var zoomAmount = _.event.params[0];
        var tweenTime = _.event.params[1];
        var tweenType = _.event.params[2];
        if (tweenTime == null && tweenType == null){ defaultCamZoom = zoomAmount;
        } else {
            if(zoomTween != null) zoomTween.cancel();
            switch(tweenType){
                case "INSTANT":
                    zoomTween = FlxTween.tween(FlxG.camera, {zoom: zoomAmount}, 0.00000000001, {onComplete: function(value) {
                        defaultCamZoom = FlxG.camera.zoom;
                    }});
                default:
                    zoomTween = FlxTween.tween(FlxG.camera, {zoom: zoomAmount}, (Conductor.stepCrochet / 1000) * tweenTime, {ease: Reflect.field(FlxEase, tweenType), onComplete: function(value) {
                        defaultCamZoom = FlxG.camera.zoom;
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