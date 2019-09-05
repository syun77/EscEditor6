package ui.message;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;

private enum State {
    Standby;
    MessageDisp; // メッセージ表示中
    PFWait;      // 改ページ待ち
}

/**
 * メッセージウィンドウ
 */
class MessageUI extends MenuUIBase {

    // 動作モード
    public static inline var PF_MODE_NONE:Int = 0; // 改行待ちしない
    public static inline var PF_MODE_WAIT:Int = 1; // 改行待ちする
    public static inline var PF_MODE_KEEP:Int = 2; // 消去しない

    // 最大3行まで
    public static inline var MAX_LINE:Int = 3;

    // テキスト設定
    static inline var TXT_POS_X:Float = 48;
    static inline var TXT_OFS_Y:Float = 12;
    static inline var TXT_SPEED:Float = 0.05;

    var _pfMode:Int = PF_MODE_NONE; // 改行モード
    var _tMessage:Float = 0;
    var _state:State = State.Standby;
    var _time:Float = 0;
    var _txts:Array<FlxText>;
    var _line:Int = 0;
    var _pf:FlxSprite;
    var _requestPF:Int = -1; // 改ページ要求

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        var py = Const.getBottom();

        _txts = new Array<FlxText>();
        for(i in 0...MAX_LINE) {
            var txt = new FlxText(TXT_POS_X, py);
            txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
            txt.visible = false;
            _txts.push(txt);
            py += txt.height;
        }

        for(txt in _txts) {
            this.add(txt);
        }

        // 改ページ待ち画像
        _pf = new FlxSprite(FlxG.width-48, py-_txts[0].height);
        _pf.loadGraphic(Resources.PF_PATH, true);
        _pf.animation.add("0", [0, 1, 2, 3, 2, 1, 0], 10);
        _pf.animation.play("0");
        this.add(_pf);
        _pf.visible = false;
    }

    /**
     * 改ページ待ちかどうか
     * @return Bool 改ページ待ちであれば true
     */
    public function isPF():Bool {
        return _state != State.Standby;
    }

    /**
     * メッセージテキストを追加する
     * @param str 追加するメッセージテキスト
     * @param pfMode ページ送りモード
     * @return Bool 追加できたらtrue
     */
    public function addText(str:String, pfMode:Int=PF_MODE_NONE):Bool {
        if(_line >= MAX_LINE) {
            return false;
        }

        _txts[_line].text = str;
        if(pfMode != PF_MODE_NONE) {
            // 改ページ要求行
            _requestPF = _line;
            _pfMode = pfMode;
        }
        _line++;
        _tMessage = 0; // メッセージ表示タイマー初期化

        if(_state == State.Standby) {
            // メッセージ表示開始
            _state = State.MessageDisp;
        }

        return true;
    }

    /**
     * テキストを消す
     */
    public function clearTexts():Void {
        _clear();       
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _time += elapsed;
        
        switch(_state) {
            case State.Standby:
            case State.MessageDisp:
                _updateMessageDisplay(elapsed);

            case State.PFWait:
                // 改ページマーク更新
                _updatePf();
                
                if(_nextPage()) {
                    if(_pfMode == PF_MODE_WAIT) {
                        // 通常の改行待ち
                        _clear();
                    }
                    // 改ページアニメ停止
                    _pf.animation.pause();
                    _state = State.Standby;
                }
        }
    }

    /**
     * 次のページに進むボタンを押したかどうか
     * @return Bool 押したらtrue
     */
    function _nextPage():Bool {
#if debug
        if(FlxG.keys.justPressed.Z) {
            return true;
        }
        if(FlxG.keys.justPressed.ENTER) {
            return true;
        }
#end
        return FlxG.mouse.justPressed;
    }

    /**
     * メッセージ表示の更新
     * @param elapsed 経過時間
     */
    function _updateMessageDisplay(elapsed:Float):Void {
        _tMessage += elapsed;
        if(_tMessage < TXT_SPEED) {
            return;
        }

        // メッセージ表示開始
        _tMessage -= TXT_SPEED;
        for(i in 0..._txts.length) {
            var txt = _txts[i];
            if(txt.visible == false) {
                txt.visible = true;
                if(i == _requestPF) {
                    // 改ページへ
                    _state = State.PFWait;
                }
                return;
            }
        }

        // 改ページ待ちしない場合はそのまま消す
        _clear();
        _state = State.Standby;
    }

    /**
     * 改ページマークの更新
     */
    function _updatePf():Void {
        _pf.visible = true;
    }

    /**
     * クリア処理
     */
    function _clear():Void {
        // テキストを消去
        for(txt in _txts) {
            txt.visible = false;
        }
        _requestPF = -1;
        _line = 0;
        _pf.visible = false;
        _pf.animation.resume();

        _pfMode = PF_MODE_NONE;
    }
}