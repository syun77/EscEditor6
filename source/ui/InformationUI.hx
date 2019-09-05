package ui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

/**
 * 状態
 */
private enum State {
    Standby;
    Appear;
    Hide;
}

/**
 * 通知メッセージウィンドウ
 */
class InformationUI extends FlxSpriteGroup {

    static inline var TIMER:Float = 3;
    static inline var OFS_Y:Float = 8;
    static inline var FADE_COLOR:Int = 0xFF505050;

    var _state:State = State.Standby;
    var _bg:FlxSprite;
    var _txt:FlxText;
    var _cnt:Float = 0;
    var _max:Float = TIMER;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        _state = State.Standby;

        // 背景
        _bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, (Resources.FONT_SIZE+6)*2, FlxColor.WHITE);
        this.add(_bg);

        // テキスト
        _txt = new FlxText(0, Const.getBottom()+OFS_Y, FlxG.width, null);
        _txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
        _txt.alignment = FlxTextAlign.CENTER;
        _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        this.add(_txt);

        _bg.y = _txt.y - 2;

        visible = false;
    }

    /**
     * 更新
     * @param elapsed 
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        switch(_state) {
            case State.Standby:
            case State.Appear:
                _cnt -= elapsed;
                {
                    // 背景更新
                    var ratio = Utils.lerpRatio(_cnt, _max-0.5, _max, FlxEase.expoIn);
                    _bg.scale.y = 1 - ratio;
                    var ratio2 = Utils.lerpRatio(_cnt, _max-0.5, _max);
                    _bg.color = FlxColor.interpolate(FADE_COLOR, FlxColor.WHITE, ratio2);
                }
                if(_cnt <= 0) {
                    _cnt = 0.5;
                    _max = _cnt;
                    _state = State.Hide;
                }
            case State.Hide:
                _cnt -= elapsed;
                var ratio = Utils.lerpRatio(_cnt, 0, _max);
                var ratio2 = Utils.lerpRatio(_cnt, 0, _max, FlxEase.expoIn);
                _txt.alpha = ratio;
                //_txt.scale.y = ratio2;
                _bg.alpha = ratio;
                _bg.scale.y = ratio2;
                if(_cnt <= 0) {
                    hide();
                }
        }
    }

    /**
     * 開始
     * @param msg メッセージ
     * @param time 表示時間
     */
    public function start(msg:String, time:Float):Void {
        _state = State.Appear;
        _max = time;
        _cnt = time;
        _bg.color = FlxColor.WHITE;
        _bg.scale.y = 0;
        _bg.alpha = 1;
        _txt.text = msg;
        _txt.scale.y = 1;
        _txt.alpha = 1;

        visible = true;
    }
    
    /**
     * 非表示にする
     */
    public function hide():Void {
        visible = false;
        _state = State.Standby;
    }
}