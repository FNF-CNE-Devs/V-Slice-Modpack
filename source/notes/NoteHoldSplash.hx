class NoteHoldSplash extends funkin.backend.FunkinSprite
{
    /*
     * Array of the color directions for the strumlines.
    */
    public var directions:Array<String> = ['Purple', 'Blue', 'Green', 'Red'];

    public function new(direction:Int){
        frames = Paths.getSparrowAtlas("game/splashes/hold/holdCover" + directions[direction]);
        animation.addByPrefix("holdEnd", "holdCoverEnd" + directions[direction], 24, false);

        playAnim('holdEnd', true);

        animation.finishCallback = () -> visible = false;
    }
}