function create() Options.gameplayShaders ? initShaders() : disableScript();

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
    boyfriend.shader = setShaderProperties(new CustomShader('adjustColor'), -23, 12, 7, 0);
    gf.shader = setShaderProperties(new CustomShader('adjustColor'), -30, -9, -4, 0);
    dad.shader = setShaderProperties(new CustomShader('adjustColor'), -33, -32, -23, 0);
}