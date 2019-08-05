package ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import esc.EscObj;

/**
 * カーソルスプライト
 */
private class CursorSprite extends FlxSprite {

    var _obj:EscObj = null;
    var _xstart:Float = 0;
    var _ystart:Float = 0;
    var _vx:Float = 0;
    var _vy:Float = 0;
    var _cnt:Float = 0;

    /**
     * コンストラクタ
     */
    public function new(obj:EscObj, px:Float, py:Float, vx:Float, vy:Float) {
        super(px, py, Resources.CURSOR_PATH);

        _obj = obj;
        _xstart = px;
        _ystart = py;
        _vx = vx;
        _vy = vy;

        visible = false;
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(_obj != null) {
            // 表示可能かどうかチェック
            visible = _obj.checkVisible();
        }

        _cnt += elapsed;
        var t = _cnt * 4;
        x = _xstart + (_vx * Math.abs(Math.sin(t)));
        y = _ystart + (_vy * Math.abs(Math.sin(t)));
    }
}

class MovingCursorUI extends FlxSpriteGroup {
    static inline var SIZE:Int = 32;
    static inline var MOVE_DISTANCE:Float = 8;
    var _cursors:Array<CursorSprite>;
    var _cnt:Float = 0;

    /**
     * コンストラクタ
     */
    public function new(movings:Array<EscObj>) {
        super();

        _cursors = new Array<CursorSprite>();

        for(obj in movings) {
            var px:Float = 0;
            var py:Float = 0;
            var vx:Float = 0;
            var vy:Float = 0;
            var rot:Float = 0;
            var d:Float = MOVE_DISTANCE;
            switch(obj.id) {
                case "left":
                    px = 8;
                    py = FlxG.height/2 - SIZE/2;
                    vx -= d;
                    rot = 180;
                case "up":
                    px = FlxG.width/2 - SIZE/2;
                    py = 8;
                    vy -= d;
                    rot = 270;
                case "right":
                    px = FlxG.width - SIZE - 8;
                    py = FlxG.height/2 - SIZE/2;
                    vx += d;
                case "down":
                    px = FlxG.width/2 - SIZE/2;
                    py = FlxG.height - SIZE - 8;
                    vy += d;
                    rot = 90;
                default:
                    throw 'Invalid obj.id: ${obj.id}';
            }
            var spr = new CursorSprite(obj, px-vx, py-vy, vx, vy);
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