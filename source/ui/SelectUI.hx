package ui;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;

/**
 * 状態
 */
private enum State {
    Standby;
    DecideWait;
    End;
}

class SelectParam {
    public var question:String = null;
    public var choices:Array<String> = null;

    public function new() {
    }
}

/**
 * 選択肢UI
 */
class SelectUI extends MenuUIBase {

    static inline var QUESTION_POS_Y:Float = 64;
    static inline var CHOICE_POS_Y:Float = 160;

    var _state:State = State.Standby;
    var _uiList:Array<ChoiceUI>;
    var _seleced:Int = -1;

    /**
     * コンストラクタ
     */
    public function new(param:SelectParam) {
        super();

        trace(param);

        // 問題文
        var strQuestion = param.question;
        var txt = new FlxText(0, QUESTION_POS_Y, FlxG.width, strQuestion);
        txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
        txt.alignment = FlxTextAlign.CENTER;
        txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        this.add(txt);

        // 選択肢
        var strArray = param.choices;

        _uiList = new Array<ChoiceUI>();
        var px:Float = 0;
        var py:Float = CHOICE_POS_Y;
        for(i in 0...strArray.length) {
            var str = strArray[i];
            var ui = new ChoiceUI(px, py, str);
            _uiList.push(ui);
            py += ChoiceUI.BG_HEIGHT + 16;
        }

        for(ui in _uiList) {
            this.add(ui);
        }
    }
    
    /**
     * 選択した番号を取得する
     * @return Int 選択した番号
     */
    public function getSelectIdx():Int {
        return _seleced;
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        switch(_state) {
            case State.Standby:
                var isDecided:Bool = false;
                for(i in 0..._uiList.length) {
                    var ui = _uiList[i];
                    if(ui.isDecided()) {
                        // 選択した
                        _seleced = i;
                        isDecided = true;
                        break;
                    }
                }
                if(isDecided) {
                    // 選択したもの以外を消去する
                    for(ui in _uiList) {
                        if(ui.isDecided() == false) {
                            ui.kill();
                        }
                    }
                    _state = State.DecideWait;
                }

            case State.DecideWait:
                var ui = _uiList[_seleced];
                if(ui.isEnd()) {
                    _state = State.End;
                    exists = false;
                }

            case State.End:
        }
    }
}