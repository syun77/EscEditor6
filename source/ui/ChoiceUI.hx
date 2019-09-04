package ui;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * 状態
 */
private enum State {
    Standby; // 待機
    Pressed; // 押している
    Decided; // 決定した
    End;     // 終了
}

/**
 * 選択項目
 */
class ChoiceUI extends FlxSpriteGroup {

    public static inline var BG_HEIGHT:Int = 48;
    static inline var BG_COLOR:Int = FlxColor.GRAY;
    static inline var BG_COLOR_PRESSED:Int = FlxColor.WHITE;

    var _state:State = State.Standby;
    var _time:Float = 0;
    var _cnt:Int = 0;
    var _bg:FlxSprite;
    var _txt:FlxText;

    /**
     * コンストラクタ
     * @param px 基準座標(X)
     * @param py 基準座標(Y)
     * @param txt テキスト
     */
    public function new(px:Float, py:Float, txt:String):Void {
        super(px, py);

        _bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, BG_HEIGHT, FlxColor.WHITE);
        _bg.color = BG_COLOR;
        this.add(_bg);

        _txt = new FlxText(0, 0, FlxG.width, txt);
        _txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
        _txt.alignment = FlxTextAlign.CENTER;
        _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        _txt.y += (BG_HEIGHT - _txt.height) / 2;
        this.add(_txt);
    }

    /**
     * 決定したかどうか
     * @return Bool 決定したら true
     */
    public function isDecided():Bool {
        return _state == State.Decided;
    }

    /**
     * 終了したかどうか
     * @return Bool 終了したら true
     */
    public function isEnd():Bool {
        return _state == State.End;
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float) {
        super.update(elapsed);

        _time += elapsed;
        _cnt++;
        _bg.color = BG_COLOR;

        switch(_state) {
            case State.Standby:
                if(FlxG.mouse.justPressed) {
                    if(Utils.checkClickSprite(_bg)) {
                        _state = State.Pressed;
                    }
                }
            case State.Pressed:
                var ratio = 0.5 + (0.25 * Math.sin(_time * 12));
                _bg.color = FlxColor.interpolate(BG_COLOR, BG_COLOR_PRESSED, ratio);
                if(Utils.checkClickSprite(_bg)) {
                    if(FlxG.mouse.justReleased) {
                        // 決定
                        _cnt = 0;
                        _state = State.Decided;
                    }
                }
                else {
                    // 選択解除
                    _state = State.Standby;
                }
            case State.Decided:
               if(_cnt%4 < 2) {
                   _bg.color = BG_COLOR_PRESSED;
               } 
               if(_cnt > 10) {
                   _state = State.End;
               }
            case State.End:
        }
    }
}
