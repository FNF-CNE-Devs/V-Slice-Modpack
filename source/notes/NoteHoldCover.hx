class NoteHoldCover extends funkin.backend.FunkinSprite
{
    /*
     * Array of the color directions for the strumlines.
    */
    public var directions:Array<String> = ['Purple', 'Blue', 'Green', 'Red', 'Purple', 'Blue', 'Green', 'Red'];

    /*
     * X Position of the hold cover.
    */
    public var posX:Float = -107.5;

    /*
     * Array of the Y Position for the hold cover (for upscroll and downscroll).
    */
    public var posY:Array<Float> = [
        0, // upscroll
        0, // downscroll
    ];

    /*
     * Whether if the note hold covers are positioned for downscroll.
    */
    public var downscroll:Bool = false;

    public function new(direction:Int, isDownscroll:Bool):Void
    {
        downscroll = isDownscroll;

        frames = Paths.getSparrowAtlas("game/splashes/hold/holdCover" + directions[direction]);
        animation.addByPrefix("start", "holdCoverStart" + directions[direction], 24, false);
        animation.addByPrefix("hold", "holdCover" + directions[direction], 24, true);

        visible = false;

        animation.finishCallback = this.onAnimationFinished;
    }

    public function updatePosition(object:FlxObject){
        x = object.x + posX;
        y = downscroll ? object.y + posY[1] : object.y + posY[0];
        angle = object.angle;
        alpha = object.alpha;
    }

    public function onAnimationFinished(animName:String):Void
        if (animName == 'start') playHold();

    public function start(){
        if (!visible && animation.name == "hold") playStart();
        else playHold();
    }

    public function playStart(){
        visible = true;
        playAnim('start');
    }

    public function playHold()
        playAnim('hold');
}