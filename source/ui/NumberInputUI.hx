package ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import esc.EscGlobal;
import ui.MenuUIBase;

/**
 * 桁ごとの数値入力UI
 */
private class DigitInputUI extends FlxSpriteGroup {

    public static inline var SPR_WIDTH:Float = Resources.INPUT_SPR_SIZE;
    public static inline var SPR_HEIGHT:Float = Resources.INPUT_SPR_SIZE;

    static inline var DEFAULT_COLOR:Int = FlxColor.GRAY;

    // 方向定数
    static inline var DIR_UP:Int   = 0;
    static inline var DIR_DOWN:Int = 1;
    static inline var DIR_MAX:Int  = 2;

    var _num:Int = 0;
    var _max:Int = 10;
    var _txt:FlxText;
    var _sprList:Array<FlxSprite>;
    var _upperY:Float = 0;
    var _bottomY:Float = 0;

    /**
     * コンストラクタ
     */
    public function new(px:Float, py:Float, num:Int) {
        super();

        // 初期数値を保持
        _num = num;
        _max = 10;

        // 上下矢印画像読み込み
        _sprList = new Array<FlxSprite>();
        var size:Float = SPR_HEIGHT;
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

        // 数字テキスト
        _txt = new FlxText(px, py, Std.int(size), '${_num}', Std.int(size));
        _txt.alignment = FlxTextAlign.CENTER;
        this.add(_txt);
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _txt.text = '${_num}';

        if(FlxG.mouse.justPressed) {
            for(i in 0..._sprList.length) {
                var spr = _sprList[i];
                var clicked = Utils.checkClickSprite(spr);
                if(clicked == false) {
                    continue;
                }

                var ynext:Float = 0;
                if(i == 0) {
                    _num++;
                    if(_num >= _max) {
                        _num = 0;
                    }
                    ynext = _upperY;
                    spr.y = ynext - (SPR_HEIGHT * 0.1);
                }
                else {
                    _num--;
                    if(_num < 0) {
                        _num = _max - 1;
                    }
                    ynext = _bottomY;
                    spr.y = ynext + (SPR_HEIGHT * 0.1);
                }
                FlxTween.color(spr, 0.1, FlxColor.WHITE, DEFAULT_COLOR);
                FlxTween.tween(spr, {y:ynext}, 0.1, {ease:FlxEase.expoOut});
            }
        }
    }

    /**
     * 数値の取得
     */
    public function getNum():Int {
        return _num;
    }
}

/**
 * 数値入力管理
 */
class NumberInputUI extends MenuUIBase {

    // 余白
    static inline var MARGIN_X:Float = 12;

    var _idx:Int = 0;
    var _digit:Int = 0;
    var _num:Int = 0;
    var _uiList:Array<DigitInputUI> = new Array<DigitInputUI>();
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
    public function open():Void {
        exists = true;

        // 生成パラメータを設定
        {
            _idx = EscGlobal.numberInputGetIdx();
            _num = EscGlobal.valGet(_idx);
        }
        {
            _digit = EscGlobal.numberInputGetDigit();
        }

        // 桁ごとの数値入力UIを生成
        _uiList = new Array<DigitInputUI>();
        var w = DigitInputUI.SPR_WIDTH;
        var h = DigitInputUI.SPR_HEIGHT;
        var ox = MARGIN_X;
        var px = (FlxG.width / 2) - ((w + ox) * _digit / 2);
        var py = (FlxG.height / 2) - (h / 2);
        for(i in 0..._digit) {
            var v = _digit - (1 + i);
            var pow = Math.pow(10, v+1);
            var div = Math.pow(10, v);
            var num = Std.int((_num % pow) / div);
            var numUI = new DigitInputUI(px, py, num);
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

        for(ui in _uiList) {
            this.remove(ui, true);
        }
        exists = false;
    }
}