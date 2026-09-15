import funkin.game.StageCharPos;
import funkin.backend.utils.MathUtil;
importScript('data/scripts/rimlight.hx');

final grayscaleValues = [0.3098039215686275, 0.607843137254902, 0.0823529411764706];
var cacheShit = [
    '' => 'this makes it a map ok'
];
function onStageNodeParsed(e) {
    //trace(e.sprite);
    //trace(e.node);
    if (e.sprite is StageCharPos)
    {
        if (cacheShit[e.name] == null) {
            cacheShit[e.name] = e.node;
        }
    }
}

function postCreate() {
    for (i in strumLines.members) {
        var charPosName:String = (i?.data?.position) ?? (switch(i.data.type) {
            case 0: "dad";
            case 1: "boyfriend";
            case 2: "girlfriend";
        });
        var n = cacheShit[charPosName];
        if ((n.get('ds_applyShader') ?? 'true').toLowerCase() != 'true') continue;

        for (char in i.characters) {
            var rim = rimlight(char);
            if (n.get('ds_threshold') != null) rim.threshold = Std.parseFloat(n.get('ds_threshold'));
            if (n.get('ds_distance') != null) rim.distance_offset = Std.parseFloat(n.get('ds_distance'));
            if (n.get('ds_angle') != null) rim.distance_angle = Std.parseFloat(n.get('ds_angle'));

            if ((n.get('ds_pixelPerfect') ?? 'true').toLowerCase() != 'true' ||
                (n.get('ds_antialiasAmt') != null && Std.parseFloat(n.get('ds_antialiasAmt')) <= 0))
                rim.smoothing = false;

            if (n.get('ds_brightness') != null) {
                final brightness = Std.parseFloat(n.get('ds_brightness'));
                for (i in 0...3) {
                    rim.matrixA[(i * 4) + 3] += (brightness / 255);
                    rim.matrixB[(i * 4) + 3] += (brightness / 255);
                }
            }
            if (n.get('ds_hue') != null) {
                hueMatrix(Std.parseFloat(n.get('ds_hue')), rim.matrixA);
                hueMatrix(Std.parseFloat(n.get('ds_hue')), rim.matrixB);
            }
            if (n.get('ds_contrast') != null) {
                final value = Std.parseFloat(n.get('ds_contrast'));
                // bullshit from dropshadow
                value = (1.0 + (value / 100.0));
                if(value > 1.0) {
                    value = (((0.00852259 * Math.pow(MathUtil.EULER, 4.76454 * (value - 1.0))) * 1.01) - 0.0086078159) * 10.0; //Just roll with it...
                    value += 1.0;
                }

                for (i in 0...3) {
                    for (poop in [rim.matrixA, rim.matrixB]) {
                        poop[(i * 4) + 3] += ((poop[(i * 4) + 3] - 0.25) * value + 0.25);
                    }
                }
            }
            if (n.get('ds_saturation') != null) {
                final satFactor = Std.parseFloat(n.get('ds_saturation'));
                // bullshit from dropshadow
                if (satFactor > 0) satFactor *= 3;
                satFactor = 1 + (satFactor / 100);
                // nightmare
                for (poop in [rim.matrixA, rim.matrixB]) {
                    for (r in 0...4) {
                        for (c in 0...4) {
                            var i = r + (c * 4);
                            if (i >= 3 * 4 || (i + 1) % 4 == 0) continue;
                            
                            poop[i] = FlxMath.lerp(grayscaleValues[r], poop[i], satFactor);
                        }
                    }
                }
            }
            if (n.get('ds_color') != null) setAddColorMatrix(FlxColor.fromString(n.get('ds_color')), rim.matrixB, true);
        }
    }
}