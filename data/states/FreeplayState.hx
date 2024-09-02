
import flixel.text.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import funkin.backend.FlxAnimate;
import funkin.backend.assets.Paths;
import haxe.io.Path;
import flixel.util.FlxTimer;
import flixel.tween.FlxTween;
import flixel.tween.FlxEase;
import backend.utils.CoolUtil;
import flixel.FlxText;
import flixel.FlxG;
import openfl.filters.GlowFilter;
import funkin.backend.shaders.CustomShader;

var dj;
var capsules:Array<FlxSpriteGroup> = [];
var realScaled = 0.8;//stuff from og freeplay
var blackBar:FlxSprite;
var triangle;
var bgDad:FlxSprite;
var freeplayText:FlxText;
var ostName:FlxText;

function postCreate() {
	//remove EVERYTHING
	remove(bg);//the ugly one
	remove(scoreText);//the ugly one
	remove(scoreBG);//the ugly one
	remove(diffText);//the ugly one
	remove(coopText);//the ugly one
	remove(grpSongs);//the ugly onesss
	for(icon in iconArray)
		remove(icon);

	triangle = new FlxSprite().loadGraphic(Paths.image('freeplay/triangle'));
	add(triangle);
	
	bgDad = new FlxSprite(triangle.width * 0.74, 0).loadGraphic(Paths.image('freeplay/bg'));
	bgDad.setGraphicSize(0, FlxG.height);
	bgDad.updateHitbox();
	add(bgDad);
	
	//DJ CODE, NOTE ITS NAMED "DJ" NOT BOYFRIEND BC IT CHANGES BETWEEN PICO AND BF 
	dj = new FlxAnimate(640, 366,Path.withoutExtension(Paths.image('freeplay/freeplay-boyfriend')));//IMPROVE-NOTE use better path 
	djPlayAnim('Boyfriend DJ',0,0);
	dj.antialiasing = true;
	add(dj);

	for(song in songs){
		var capsuleGroup:FlxSpriteGroup = new FlxSpriteGroup(400,songs.indexOf(song)*100);
		add(capsuleGroup);

		var capsule:FlxSprite = new FlxSprite(0,0);
		capsule.frames = Paths.getSparrowAtlas('freeplay/freeplayCapsule');
		capsule.animation.addByPrefix('selected', 'mp3 capsule w backing0', 24);
		capsule.animation.addByPrefix('unselected', 'mp3 capsule w backing NOT SELECTED', 24);	
		capsule.animation.play('selected');
		capsule.scale.set(realScaled,realScaled);
		capsuleGroup.add(capsule);

		/*var text:FlxText = new FlxText(160,45,0,song.displayName,20);
		capsuleGroup.add(text);*/

        var titleTextBlur = new FlxText(capsule.width * 0.26, 45,0, song.displayName, Std.int(40 * realScaled));
        titleTextBlur.font = "5by7";
        titleTextBlur.color = 0xFF00ccff;
        titleTextBlur.shader = new CustomShader('GaussianBlurShader');
		//IMPROVE-NOTE something something low quailty option
        capsuleGroup.add(titleTextBlur);

        var text = new FlxText(capsule.width * 0.26, 45,0,song.displayName, Std.int(40 * realScaled));
        text.font = Paths.font("5by7.ttf");
        text.textField.filters = [
            new GlowFilter(0x00ccff, 1, 5, 5, 210, 2/*BitmapFilterQuality.MEDIUM*/),
          ];
        capsuleGroup.add(text);

		capsules.push(capsuleGroup);
	}

    blackBar = new FlxSprite().makeGraphic(FlxG.width, 64, 0xFF000000);
    add(blackBar);
        
	freeplayText = new FlxText(8, 8, 0, 'FREEPLAY', 48);
	add(freeplayText);
	
	ostName = new FlxText(8, 8, FlxG.width - 8 - 8, 'OFFICIAL OST', 48);//should make this change
	ostName.alignment = "right";
	add(ostName);

	freeplayText.font = ostName.font = 'VCR OSD Mono';

	intro();
}

function getItemFromCapsule(capsule,itemName){
	if(capsule != null){
		switch(itemName){
			case 'capsule':
				return capsule.members[0];
			case 'textBlur':
				return capsule.members[1];
			case 'text':
				return capsule.members[2];
		}
	}
	return null;
}

function djPlayAnim(name,offsetX,offsetY){
	dj.anim.play(name,true);
	dj.offset.set(offsetX,offsetY);
}

function intro(){
	//bf
	djPlayAnim("boyfriend dj intro",6.7,2.6);
	
	//black bar
    blackBar.y -= blackBar.height;
    FlxTween.tween(blackBar, {y: 0}, 0.3, {ease: FlxEase.quartOut});
	
	freeplayText.visible= ostName.visible = false;

	//bg dad
	bgDad.color = 0xFF000000;
	var ogbgDadX = bgDad.x;//sillies
	bgDad.x = FlxG.width;
	FlxTween.tween(bgDad,{x:ogbgDadX},0.7,{ease: FlxEase.quintOut});

	//yellow/pink triangle
	//IMPROVE-NOTE change this to be less lines, you can do it idiot
	//removes all color
	triangle.colorTransform.redMultiplier = 0;
	triangle.colorTransform.greenMultiplier = 0;
	triangle.colorTransform.blueMultiplier = 0;
	//set the color to pink by rgb
	triangle.colorTransform.redOffset = 255;
	triangle.colorTransform.greenOffset = 212;
	triangle.colorTransform.blueOffset = 233;
	triangle.x -= triangle.width;
	FlxTween.tween(triangle,{x:0},0.6,{ease: FlxEase.quartOut});
}

function onIdleStart(){
	//black bar stuff
	freeplayText.visible = ostName.visible = true;

	//to make that effect ninja muffin wanted ig
	freeplayText.scale.y = ostName.scale.y = 1.1;
	new FlxTimer().start(1.5 / 24, function(__) freeplayText.scale.y = ostName.scale.y = 1);


	//triangle stuff
	triangle.setColorTransform();//removes the color effect

	//bg dad stuff
	bgDad.color = 0xFFFFFFFF;
}

function update(){
	if(dj.anim.curFrame >= dj.anim.length - 1){//flxanimate sucks,i cant set the loop type https://github.com/FNF-CNE-Devs/flxanimate/blob/5be6822b5262230e19c975d50c8a1e2e44be10ba/flxanimate/animate/FlxAnim.hx#L189C11-L189C19
		if(dj.anim.curSymbol.name == "boyfriend dj intro"){
			djPlayAnim('Boyfriend DJ',0,0);

			onIdleStart();
		}
	}
	if(FlxG.keys.justPressed.I)
		intro();
	for(capsule in capsules){
		var targetIndex = (capsules.indexOf(capsule)-curSelected)+1/**???**/;
		var targetY = (targetIndex * ((capsule.height * realScaled) + 10)) + 120;
		if (capsules.indexOf(capsule)+1 < curSelected) targetY -= 100;
		var targetX = 270 + (60 * (Math.sin(targetIndex)));

		capsule.y = CoolUtil.fpsLerp(capsule.y,targetY,0.4);
		capsule.x =  CoolUtil.fpsLerp(capsule.x,targetX,0.4);
	}
}

var alreadCanceledSelect = false;
function onSelect(event){
	if(!alreadCanceledSelect){
		event.cancel();
		alreadCanceledSelect = true;

		dj.anim.play('Boyfriend DJ confirm');
		CoolUtil.playMenuSFX(1/**ACCEPT**/, 0.7);

		new FlxTimer().start(1.0,function(_){
			select();
		});
	}
}
function onUpdateOptionsAlpha(event){
	event.cancel();
	
	for (i=>item in grpSongs.members)
		item.targetY = i - curSelected;
}

function onChangeSelection(event){
	for(capsule in capsules){
		if(event.value == capsules.indexOf(capsule)){
			getItemFromCapsule(capsule,'capsule').animation.play('selected');
			getItemFromCapsule(capsule,'textBlur').visible = true;
			getItemFromCapsule(capsule,'text').alpha = 1;
			getItemFromCapsule(capsule,'capsule').offset.x = 0;
		}
		else{
			getItemFromCapsule(capsule,'capsule').animation.play('unselected');
			getItemFromCapsule(capsule,'textBlur').visible = false;
			getItemFromCapsule(capsule,'text').alpha = 0.6;
			getItemFromCapsule(capsule,'capsule').offset.x = -5;
		}
	}
}