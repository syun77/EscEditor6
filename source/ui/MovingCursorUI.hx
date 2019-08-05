package ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;

/**
 * カーソルスプライト
 */
private class CursorSprite extends FlxSprite {

    var _xstart:Float = 0;
    var _ystart:Float = 0;
    var _vx:Float = 0;
    var _vy:Float = 0;
    var _cnt:Float = 0;

    /**
     * コンストラクタ
     */
    public function new(px:Float, py:Float, vx:Float, vy:Float) {
        super(px, py, Resources.CURSOR_PATH);

        _xstart = px;
        _ystart = py;
        _vx = vx;
        _vy = vy;
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        _cnt += elapsed;
        var t = _cnt * 4;
        x = _xstart + (_vx * Math.abs(Math.sin(t)));
        y = _ystart + (_vy * Math.abs(Math.sin(t)));
    }
}

class MovingCursorUI extends FlxSpriteGroup {
    static inline var SIZE:Int = 32;
    static inline var MOVE_DISTANCE:Float = 16;
    var _cursors:Array<CursorSprite>;
    var _cnt:Float = 0;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        _cursors = new Array<CursorSprite>();

        for(i in 0...Direction.MAX) {
            var px:Float = 0;
            var py:Float = 0;
            var vx:Float = 0;
            var vy:Float = 0;
            var rot:Float = 0;
            var d:Float = MOVE_DISTANCE;
            switch(i) {
                case Direction.LEFT:
                    px = 8;
                    py = FlxG.height/2 - SIZE/2;
                    vx -= d;
                    rot = 180;
                case Direction.UP:
                    px = FlxG.width/2 - SIZE/2;
                    py = 8;
                    vy -= d;
                    rot = 270;
                case Direction.RIGHT:
                    px = FlxG.width - SIZE - 8;
                    py = FlxG.height/2 - SIZE/2;
                    vx += d;
                case Direction.DOWN:
                    px = FlxG.width/2 - SIZE/2;
                    py = FlxG.height - SIZE - 8;
                    vy += d;
                    rot = 90;
            }
            var spr = new CursorSprite(px-vx, py-vy, vx, vy);
            spr.angle = rot;
            _cursors.push(spr);
        }

        for(spr in _cursors) {
            this.add(spr);
        }
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }
}