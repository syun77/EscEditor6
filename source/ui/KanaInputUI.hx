package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import esc.EscGlobal;
import dat.KanaDB;

/**
 * カナ文字入力UI
 */
private class KanaUI extends FlxSpriteGroup {
    public static inline var SIZE:Float = Resources.INPUT_SPR_SIZE;
    public static inline var TEXT_SIZE:Int = 60;

    static inline var ARROW_COLOR:Int = 0xFFc0c0c0;
    static inline var TEXT_COLOR:Int = FlxColor.WHITE;
    static inline var TEXT_OUTLINE_COLOR:Int = FlxColor.BLACK;
    static inline var TEXT_OFS_X:Int = -2;
    static inline var TEXT_OFS_Y:Int = -4;

    // 方向定数
    static inline var DIR_UP:Int   = 0;
    static inline var DIR_DOWN:Int = 1;
    static inline var DIR_MAX:Int  = 2;

    // メンバ変数
    var _txt:FlxText;
    var _idx:Int = 0;
    var _max:Int = 0;
    var _sprList:Array<FlxSprite>;
    var _strList:Array<String>;
    var _upperY:Float = 0;
    var _bottomY:Float = 0;

    /**
     * コンストラクタ
     * @param px 座標(X)
     * @param py 座標(Y)
     * @param idx 初期選択番号
     * @param strList 文字配列
     */
    public function new(px:Float, py:Float, idx:Int, strList:Array<String>) {
        super();

        // 初期数値を保持
        _idx = idx;
        _max = strList.length;
        _strList = strList;

        // 上下矢印画像読み込み
        _sprList = new Array<FlxSprite>();
        var size:Float = SIZE;
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
            spr.color = ARROW_COLOR;
            _sprList.push(spr);
        }

        for(spr in _sprList) {
            this.add(spr);
        }

        // 入力文字テキスト
        _txt = new FlxText(px, py, SIZE, strList[idx], TEXT_SIZE);
        _txt.setFormat(Resources.FONT_PATH, TEXT_SIZE);
        _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, TEXT_OUTLINE_COLOR);
        _txt.alignment = FlxTextAlign.CENTER;
        this.add(_txt);
    }

    public function getText():String {
        return _strList[_idx];
    }

    public function getIdx():Int {
        return _idx;
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // テキスト
        _txt.text = getText();

        // クリック判定
        if(FlxG.mouse.justPressed) {
            for(i in 0..._sprList.length) {
                var spr = _sprList[i];
                var clicked = Utils.checkClickSprite(spr);
                if(clicked == false) {
                    continue;
                }

                var ynext:Float = 0;
                if(i == DIR_UP) {
                    // 上に移動
                    _idx--;
                    if(_idx < 0) {
                        _idx = _max - 1;
                    }
                    ynext = _upperY;
                    spr.y = ynext - (SIZE * 0.1);
                }
                else {
                    // 下に移動
                    _idx++;
                    if(_idx >= _max) {
                        _idx = 0;
                    }
                    ynext = _bottomY;
                    spr.y = ynext + (SIZE* 0.1);
                }
                FlxTween.color(spr, 0.1, FlxColor.WHITE, ARROW_COLOR);
                FlxTween.tween(spr, {y:ynext}, 0.1, {ease:FlxEase.expoOut});
            }
        }
    }
}

/**
 * 状態
 */
private enum State {
    Standby;
    CorrectWait; // 正解待ち
}

/**
 * 文字入力UI
 */
class KanaInputUI extends MenuUIBase {
    
    // 余白
    static inline var MARGIN_X:Float = 12;

    var _state:State = State.Standby;
    var _cnt:Int = 0;
    var _timer:Float = 0;
    var _kanaID:Int = 0;
    var _uiList:Array<KanaUI> = new Array<KanaUI>();
    var _okSpr:FlxSprite; // OKボタン
    var _bg:FlxSprite;
    var _idx:Int = 0; // 結果を保存するグローバル変数番号
    var _value:Int; // 入力している値
    var _autoCheck:Bool = false; // 自動正解チェックを行うかどうか
    var _answer:String = ""; // 正解文字列
    var _result:Bool = false; // 正解したら true

    /**
     * コンストラクタ
     * @param kanaID 文字入力番号
     */
    public function new(kanaID:Int) {
        super();

        _kanaID = kanaID;
        var mojiList:Array<String> = new Array<String>();
        {
            // 文字入力情報を取得する
            var kana = KanaDB.get(_kanaID);
            _idx       = kana.idx;        // 保存グローバル変数番号 
            _answer    = kana.answer;     // 正解文字列
            _autoCheck = kana.auto_check; // 自動正解チェックを行うかどうか
            for(moji in kana.choices) {
                mojiList.push(moji.moji);
            }
        }
        _value = 0;
        if(_idx > 0) {
            // 変数番号が指定されていれば変数値を取得する
            _value = EscGlobal.valGet(_idx);
        }
        var strLength = mojiList.length;

        // 背景
        {
            var bgHeight = Std.int(Resources.INPUT_SPR_SIZE*4);
            _bg = new FlxSprite(0, Const.getCenterY()).makeGraphic(FlxG.width, bgHeight, FlxColor.BLACK);
            _bg.y -= _bg.height/2;
            _bg.alpha = 0.3;
            this.add(_bg);
        }

        // OKボタン
        {
            var px = FlxG.width/2;
            var py = Const.getBottom() * 4 / 5;
            var spr = new FlxSprite(px, py, Resources.BTN_OK_PATH);
            spr.x -= spr.width/2;
            spr.y -= spr.height/2;
            _okSpr = spr;
            this.add(_okSpr);
        }

        // 桁ごとの文字入力UIを生成
        _uiList = new Array<KanaUI>();
        var w = KanaUI.SIZE;
        var h = KanaUI.SIZE;
        var ox = MARGIN_X;
        var px = (FlxG.width / 2) - ((w + ox) * strLength / 2);
        var py = Const.getCenterY() - (h / 2);
        for(i in 0...strLength) {
            var strList = new Array<String>();
            var len = haxe.Utf8.length(mojiList[i]);
            for(j in 0...len) {
                strList.push(haxe.Utf8.sub(mojiList[i], j, 1));
            }
            var v = strLength - (1 + i);
            var pow = Math.pow(10, v+1);
            var div = Math.pow(10, v);
            var num = Std.int((_value % pow) / div);
            var ui = new KanaUI(px, py, num, strList);
            // 前に追加
            _uiList.unshift(ui);

            px += w + ox;
        }

        for(ui in _uiList) {
            this.add(ui);
        }
    }

    /**
     * 結果取得
     * @return Bool 正解したら true
     */
    public function getResult():Bool {
        return _result;
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        _timer += elapsed;
        _cnt++;

        switch(_state) {
            case State.Standby:
                _updateStandby();
            case State.CorrectWait:
                _updateCorrectWait();
        }

    }

    /**
     * 更新・待機
     */
    function _updateStandby():Void {
        if(_idx > 0) {
            // 入力した値を反映
            _value = 0;
            for(i in 0..._uiList.length) {
                var ui = _uiList[i];
                _value += Std.int(ui.getIdx() * Math.pow(10, i));
            }

            // グローバルデータに反映
            EscGlobal.valSet(_idx, _value);
        }

        if(_checkAnswer()) {
            // 正解
            _result = true;
            // 正解演出開始
            _state = State.CorrectWait;
            _cnt = 0;
            // ボタンを決しておく
            _okSpr.visible = false;
            return;
        }

        if(FlxG.mouse.justPressed) {
            if(Utils.checkClickSprite(_okSpr)) {
                // OKボタンをクリックした
                _close();
            }
        }
    }

    /**
     * 正解チェック
     * @return Bool 正解していたらtrue
     */
    function _checkAnswer():Bool {
        var str = "";
        for(ui in _uiList) {
            str = ui.getText() + str; // 逆順に足しこむ必要がある
        }

        return _answer == str;
    }

    /**
     * 更新・正解演出終了待ち
     */
    function _updateCorrectWait():Void {
        if(_cnt > 60) {
            _close();
        }
    }

    /**
     * 閉じたかどうか
     * @return Bool 閉じたらtrue
     */
    override public function isClosed():Bool {
        return exists == false;
    }

    /**
     * 閉じる
     */
    function _close():Void {
        for(ui in _uiList) {
            this.remove(ui, true);
            FlxDestroyUtil.destroy(ui);
        }
        exists = false;
    }
}