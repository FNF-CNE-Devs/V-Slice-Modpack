function create()
{
    colorShader = new CustomShader('adjustColor');
    colorShader.hue = 5;
    colorShader.saturation = 20;

    for (character in [boyfriend, gf, dad, santa]) character.shader = colorShader;
    gf.animateAtlas?.shaderEnabled = gf.shaderEnabled = true;
}