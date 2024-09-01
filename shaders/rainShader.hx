/*typedef Light =
{
  var position:Array<Float>;
  var color:Array<Float>;
  var radius:Float;
}*/

final MAX_LIGHTS:Int = 8;

var lights:Array<{
	position:ShaderParameter<Float>,
	color:ShaderParameter<Float>,
	radius:ShaderParameter<Float>,
}>;
registerField("lights", ()->lights, (value)->lights = value);

var time:Float = 1;
registerShaderField("time", "uTime");

// The scale of the rain depends on the world coordinate system, so higher resolution makes
// the raindrops smaller. This parameter can be used to adjust the total scale of the scene.
// The size of the raindrops is proportional to the value of this parameter.
var scale:Float = 1;
registerShaderField("scale", "uScale");

// The intensity of the rain. Zero means no rain and one means the maximum amount of rain.
var intensity:Float = 0.5;
registerShaderField("intensity", "uIntensity");

// the y coord of the puddle, used to mirror things
var puddleY:Float = 0;
registerShaderField("puddleY", "uPuddleY");

// the y scale of the puddle, the less this value the more the puddle effects squished
var puddleScaleY:Float = 0;
registerShaderField("puddleScaleY", "uPuddleScaleY");

var blurredScreen:BitmapData;
registerShaderField("blurredScreen", "uBlurredScreen");

var mask:BitmapData;
registerShaderField("mask", "uMask");

var lightMap:BitmapData;
registerShaderField("lightMap", "uLightMap");

var numLightsSwag:Int = 0; // swag heads, we have never been more back (needs different name purely for hashlink casting fix)
registerShaderField("numLightsSwag", "numLights");


function update(elapsed:Float):Void
{
	this.time += elapsed;
}

function processGLDataPost(e:ShaderProcessEvent):Void
{
	if (e.storageType == 'uniform')
	{
		lights = [
			for (i in 0...MAX_LIGHTS)
			{
				position: registerParameter('lights['+i+'].position', "vec2"),
				color: registerParameter('lights['+i+'].color', "vec3"),
				radius: registerParameter('lights['+i+'].radius', "float"),
			}
		];
	}
}