import flixel.addons.display.FlxBackdrop;

var fastCarCanDrive:Bool = true;

var shootingStarBeat:Int = 0;
var shootingStarOffset:Int = 2;

importScript("data/scripts/erect-effect");

function create()
{
	resetFastCar();

	initMist();

	shootingStar.animation.finishCallback = () -> shootingStar.visible = false;
}

var mists:Array<FlxBackdrop> = [];
function initMist()
{
	// Type of mist, X Position, Y Position, Scroll, Scale, Color, Alpha, X Velocity
	var mistData:Array<Dynamic> = [
		['Mid', -650, -100, 1.1, 1.3, 0xFFc6bfde, 0.4, 1700],
		['Back', -650, -100, 1.2, 1, 0xFF6a4da1, 1, 2100],
		['Mid', -650, -100, 0.8, 1.5, 0xFFa7d9be, 0.5, 900],
		['Back', -650, -380, 0.6, 1.5, 0xFF9c77c7, 1, 700],
		['Mid', -650, -100, 0.5, 1.5, 0xFFE7A480, 1, 100]
	];

	for (mist in mistData) {
		var mistBackdrop = new FlxBackdrop(Paths.image('stages/limo/erect/mist' + mist[0]), 0x01);
		mistBackdrop.setPosition(mist[1], mist[2]);
		mistBackdrop.scrollFactor.set(mist[3], mist[3]);
		mistBackdrop.scale.set(mist[4], mist[4]);
		mistBackdrop.color = mist[5];
		mistBackdrop.alpha = mist[6];
		mistBackdrop.velocity.x = mist[7];
		mistBackdrop.blend = 0;
		
		mists.push(mistBackdrop);
	}

	insert(members.indexOf(skyBG) + 1, mists[4]);
	insert(members.indexOf(bgLimo) + 1, mists[3]);
	insert(members.indexOf(bgLimo) + 1, mists[2]);
	insert(members.indexOf(dad) + 1, mists[0]);
	insert(members.indexOf(dad) + 1, mists[1]);
}

var _timer:Float = 0;
function update(elapsed:Float) {
	_timer += elapsed;
	mists[0].y = 100 + (Math.sin(_timer) * 200);
	mists[1].y = 0 + (Math.sin(_timer * 0.8) * 100);
	mists[2].y = -20 + (Math.sin(_timer * 0.5) * 200);
	mists[3].y = -180 + (Math.sin(_timer * 0.4) * 300);
	mists[4].y = -450 + (Math.sin(_timer * 0.2) * 150);

	if (!fastCarCanDrive && fastCar.x > 2000) {
		resetFastCar();
		fastCarCanDrive = true;
	}

	// back limo drive
	if (Options.lowMemoryMode) {
		bgLimo.frameOffset.x = Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * 85;
	} else {
		for(e in [bgLimo, dancer1, dancer2, dancer3, dancer4, dancer5]) {
			e.frameOffset.x = Math.sin(curBeatFloat / 4) * Math.cos(curBeatFloat / 16) * 85;
		}
	}
}

function beatHit(curBeat:Int) {
	if (FlxG.random.bool(10))
    {
        if (fastCarCanDrive)
            fastCarDrive();

        if (curBeat > (shootingStarBeat + shootingStarOffset))
            doShootingStar(curBeat);
    }
}

function doShootingStar(beat:Int):Void
{
	shootingStar.x = FlxG.random.int(50,900);
	shootingStar.y = FlxG.random.int(-10,20);
	shootingStar.flipX = FlxG.random.bool(50);
	shootingStar.visible = true;
	shootingStar.playAnim('shootingStar');
    
	shootingStarBeat = beat;
	shootingStarOffset = FlxG.random.int(4, 8);
}

function resetFastCar() {
	fastCar.x = -12600;
	fastCar.y = FlxG.random.int(140, 250);
	fastCar.velocity.x = 0;
	fastCarCanDrive = true;
}

function fastCarDrive()
{
	FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

	fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
	fastCarCanDrive = false;
}