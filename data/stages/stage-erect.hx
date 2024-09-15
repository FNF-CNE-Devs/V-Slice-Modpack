function create()
{
    for (lights in [brightLightSmall, orangeLight, lightgreen, lightred, lightAbove])
        lights.blend = 0;

    initShaders();
}

function setShaderProperties(shader:CustomShader, brightness:Float, hue:Float, contrast:Float, saturation:Float = 0):CustomShader
{
    shader.brightness = brightness;
    shader.hue = hue;
    shader.contrast = contrast;
    shader.saturation = saturation;
    return shader;
}

function initShaders()
{
    colorShaderBf = setShaderProperties(new CustomShader('adjustColor'), -23, 12, 7, 0);
    colorShaderGf = setShaderProperties(new CustomShader('adjustColor'), -30, -9, -4, 0);
    colorShaderDad = setShaderProperties(new CustomShader('adjustColor'), -33, -32, -23, 0);

    boyfriend.shader = colorShaderBf;

    gf.animateAtlas?.shaderEnabled = gf.shaderEnabled = true;
    gf.shader = colorShaderGf;
    
    dad.shader = colorShaderDad;
}