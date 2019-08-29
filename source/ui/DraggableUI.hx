package ui;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * 状態
 */
private enum State {
    Standby; // 待機状態
    Dragged; // ドラッグ移動中
    JustReleased; // ドラッグを解放した瞬間
}

class DraggableUI extends FlxSprite {

    static inline var RETURNING_SPEED:Float = 0.2;

    /**
     * パラメータ
     */
    public var param(get, never):Int;
    var _param:Int = 0;
    function get_param():Int {
        return _param;
    }
    public function setParam(v:Int):Void {
        _param = v;
    }

    /**
     * 開始座標(X)
     */
    public var xstart(get, never):Float;
    var _xstart:Float = 0;
    function get_xstart():Float {
        return _xstart;
    }

    /**
     * 開始座標(Y)
     */
    public var ystart(get, never):Float;
    var _ystart:Float = 0;
    function get_ystart():Float {
        return _ystart;
    }

    var _xclicked:Float = 0;
    var _yclicked:Float = 0;
    var _draggable:Bool = true;
    var _isWait:Bool = false;

    /**
     * 状態
     */
    var _state:State = State.Standby;

    /**
     * コンストラクタ
     * @param px 開始座標(X)
     * @param py 開始座標(Y)
     * @param SimpleGraphic 画像データ
     * @param 
     */
    public function new(px:Float, py:Float, ?SimpleGraphic:FlxGraphicAsset) {
        super(px, py, SimpleGraphic);

        setStart(px, py);

        _state = State.Standby;
        _isWait = false;
    }

    /**
     * 戻り演出が終わったかどうか
     * @return Bool 終わったら true
     */
    public function isEndReturn():Bool {
        if(_state != State.Standby) {
            return false;
        }

        var dx = _xstart - x;
        var dy = _ystart - y;
        return Math.sqrt(dx*dx + dy*dy) < 1;
    }

    /**
     * ドラッグ処理の有効フラグ設定
     * @param b trueなら有効
     */
    public function setDraggable(b:Bool):Void {
        _draggable = b;
    }

    /**
     * 開始座標の設定
     * @param px 開始座標(X)
     * @param py 開始座標(Y)
     */
    public function setStart(px:Float, py:Float):Void {
        _xstart = px;
        _ystart = py;
    }

    /**
     * ドラッグ移動中かどうか
     * @return Bool ドラッグ移動中ならば true
     */
    public function isDragged():Bool {
        return _state == State.Dragged;
    }
    public function isJustReleased():Bool {
        return _state == State.JustReleased;
    }
    public function endWait():Void {
        _isWait = false;
    }

    /**
     * ドラッグ移動をキャンセルする
     */
    public function cancelToDrag():Void {
        endWait();
        _state = State.Standby;
    }

    /**
     * 移動距離が半径の半分以下
     * @return Bool
     */
    public function isMovingDistanceHalf():Bool {
        var dx = x - _xstart;
        var dy = y - _ystart;
        return (dx*dx)+(dy*dy) < width*height;
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        switch(_state) {
            case State.Standby:
                var dx = (_xstart - x);
                var dy = (_ystart - y);
                x += dx * RETURNING_SPEED;
                y += dy * RETURNING_SPEED;
                if(_draggable) {
                    if(FlxG.mouse.justPressed) {
                        if(Utils.checkClickSprite(this)) {
                            _xclicked = x - FlxG.mouse.x;
                            _yclicked = y - FlxG.mouse.y;
                            _state = State.Dragged;
                        }
                    }
                }

            case State.Dragged:
                x = FlxG.mouse.x + _xclicked;
                y = FlxG.mouse.y + _yclicked;
                if(FlxG.mouse.justReleased) {
                    _state = State.JustReleased;
                    _isWait = true;
                }
            case State.JustReleased:
                if(_isWait == false) {
                    _state = State.Standby;
                }

        }
    }
}