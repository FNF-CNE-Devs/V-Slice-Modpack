var duetChange:Bool = false;
var camShit:Int = 0;
import flixel.math.FlxPoint;
function onEvent(_){
    switch(_.event.name){
        case 'Duet Camera':
            camShit = defaultCamZoom;
            duetChange = true;
            defaultCamZoom -= _.event.params[0];
        case 'Camera Movement':
            if(duetChange){
                defaultCamZoom = camShit;
                duetChange = false;
            }
    }
}

function postUpdate(){
    if(duetChange){
        camFollow.x = gf.getMidpoint().x;
        camFollow.y = dad.getMidpoint().y;
    }
}