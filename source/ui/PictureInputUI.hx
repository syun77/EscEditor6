package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSubState;
import esc.EscGlobal;
import ui.MenuUIBase;

/**
 * 画像撰択UI
 */
private class ImageInputUI extends FlxSpriteGroup {
    public static inline var SPR_SIZE:Float = Resources.INPUT_SPR_SIZE;
    static inline var DEFAULT_COLOR:Int = FlxColor.GRAY;

    // 方向定数
    static inline var DIR_UP:Int   = 0;
    static inline var DIR_DOWN:Int = 1;
    static inline var DIR_MAX:Int  = 2;

    var _num:Int = 0;
    var _max:Int = 0;
    var _digit:Int = 0;
    var _digitMax:Int = 0;
    var _sprList:Array<FlxSprite>;
    var _upperY:Float = 0;
    var _bottomY:Float = 0;
    var _pictureSpr:FlxSprite;

    /**
     * コンストラクタ
     * @param px 描画座標(X)
     * @param py 描画座標(Y)
     * @param num 初期数値
     * @param digit 桁番号
     * @param inputNo 入力番号
     */
    public function new(px:Float, py:Float, num:Int, digit:Int, inputNo:Int) {
        super();

        trace('num=${num} digit=${digit} picture=${inputNo}');

        // 初期数値を保持
        _num = num;
        _digit = digit;

        // 上下矢印画像読み込み
        _sprList = new Array<FlxSprite>();
        var size:Float = SPR_SIZE;
        for(i in 0...DIR_MAX) {
            var spr = new FlxSprite(0, 0, Resources.NUM_ARROW);
            var px2 = px;
            var py2 = py;
            var rot:Float = 0;
            if(i == DIR_UP) {
                // 上
                py2 = py - size;
                _upperY = py2;
            }
            else {
                // 下
                py2 = py + size * 1.1;
                rot = 180;
                _bottomY = py2;
            }
            spr.x = px2;
            spr.y = py2;
            spr.angle = rot;
            spr.color = DEFAULT_COLOR;
            _sprList.push(spr);
        }

        for(spr in _sprList) {
            this.add(spr);
        }

        // 入力画像の読み込み
        _pictureSpr = new FlxSprite(px, py);
        
        var size:Int = Std.int(SPR_SIZE);
        _pictureSpr.loadGraphic(Resources.getInputPicturePath(inputNo), true, size, size);
        _max = Std.int(_pictureSpr.pixels.height / SPR_SIZE);
        _digitMax = Std.int(_pictureSpr.pixels.width / SPR_SIZE);
        trace('width=${_pictureSpr.pixels.width} height=${_pictureSpr.height} max=${_max} digitMax=${_digitMax}');
        for(i in 0...(_max * _digitMax)) {
            _pictureSpr.animation.add('${i}', [i], 1);
        }

        trace((_digit * _max) + _num);
        _updatePicture();
        this.add(_pictureSpr);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _updatePicture();

        if(FlxG.mouse.justPressed) {
            for(i in 0..._sprList.length) {
                var spr = _sprList[i];
                var clicked = Utils.checkClickSprite(spr);
                if(clicked == false) {
                    continue;
                }

                var ynext:Float = 0;
                if(i == DIR_UP) {
                    // 減算
                    _num--;
                    if(_num < 0) {
                        _num = _max - 1;
                    }
                    ynext = _upperY;
                    spr.y = ynext - (SPR_SIZE * 0.1);
                }
                else {
                    // 加算
                    _num++;
                    if(_num >= _max) {
                        _num = 0;
                    }
                    ynext = _bottomY;
                    spr.y = ynext + (SPR_SIZE * 0.1);
                }
                FlxTween.color(spr, 0.1, FlxColor.WHITE, DEFAULT_COLOR);
                FlxTween.tween(spr, {y:ynext}, 0.1, {ease:FlxEase.expoOut});
            }
        }
    }

    public function getNum():Int {
        return _num;
    }

    function _updatePicture():Void {
        //var idx = (_digit * _max) + _num;
        var idx = (_num * _digitMax) + _digit;
        _pictureSpr.animation.play('${idx}');
    }
}

/**
 * 画像入力管理
 */
class PictureInputUI extends MenuUIBase {

    // 余白
    static inline var MARGIN_X:Float = 12;

    var _idx:Int = 0;
    var _digit:Int = 0;
    var _num:Int = 0;
    var _uiList:Array<ImageInputUI> = new Array<ImageInputUI>();
    var _okSpr:FlxSprite; // OKボタン

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        // OKボタン
        {
            var px = FlxG.width/2;
            var py = FlxG.height * 4 / 5;
            var spr = new FlxSprite(px, py, Resources.BTN_OK_PATH);
            spr.x -= spr.width/2;
            spr.y -= spr.height/2;
            _okSpr = spr;
            this.add(_okSpr);
        }

        exists = false;
    }

    /**
     * 開く
     */
    public function open(pictureID:Int, digit:Int):Void {

        exists = true;

        // 生成パラメータを設定
        {
            _idx = EscGlobal.numberInputGetIdx();
            _num = EscGlobal.valGet(_idx);
        }
        _digit = digit;

        // 桁ごとの数値入力UIを生成
        _uiList = new Array<ImageInputUI>();
        var w = ImageInputUI.SPR_SIZE;
        var h = ImageInputUI.SPR_SIZE;
        var ox = MARGIN_X;
        var px = (FlxG.width / 2) - ((w + ox) * _digit / 2);
        var py = (FlxG.height / 2) - (h / 2);
        for(i in 0..._digit) {
            var v = _digit - (1 + i);
            var pow = Math.pow(10, v+1);
            var div = Math.pow(10, v);
            var num = Std.int((_num % pow) / div);
            var numUI = new ImageInputUI(px, py, num, i, pictureID);
            // 前に追加
            _uiList.unshift(numUI);

            px += w + ox;
        }

        for(ui in _uiList) {
            this.add(ui);
        }


    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        //　入力した値を反映
        _num = 0;
        for(i in 0..._uiList.length) {
            var ui = _uiList[i];
            _num += Std.int(ui.getNum() * Math.pow(10, i));
        }

        // グローバルデータに反映
        EscGlobal.valSet(_idx, _num);

#if debug
        if(FlxG.keys.justPressed.X) {
            _close();
        }
#end
        if(FlxG.mouse.justPressed) {
            if(Utils.checkClickSprite(_okSpr)) {
                // OKボタンをクリックした
                _close();
            }
        }
    }

    override public function isClosed():Bool {
        return exists == false;
    }

    function _close():Void {
        exists = false;

        for(ui in _uiList) {
            this.remove(ui, true);
        }
    }
}