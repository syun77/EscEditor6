package ui;

import ui.MenuUIBase;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import ui.DraggableUI;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.text.FlxText;
import dat.PanelDB;
import esc.EscGlobal;

class DragPanelUI extends DraggableUI {
    // public.
    public static inline var BG_COLOR:Int = 0xFFa0a0a0;

    // private.
    static inline var SIZE:Int = 64;

    static inline var TEXT_COLOR:Int = FlxColor.WHITE;
    static inline var TEXT_OUTLINE_COLOR:Int = FlxColor.BLACK;
    static inline var TEXT_OFS_X:Int = -2;
    static inline var TEXT_OFS_Y:Int = -4;

    var _txt:FlxText;
    var _xorigin:Float = 0;
    var _yorigin:Float = 0;

    /**
     * コンストラクタ
     * @param px 座標(X)
     * @param py 座標(Y)
     * @param str 文字
     */
    public function new(px:Float, py:Float, str:String) {
        super(px, py, Resources.PANEL_BG_PATH);
        color = BG_COLOR;

        _txt = new FlxText(px, py, SIZE, str, SIZE);
        _txt.color = TEXT_COLOR;
        _txt.setFormat(Resources.FONT_PATH, SIZE);
        _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, TEXT_OUTLINE_COLOR);

        _xorigin = px;
        _yorigin = py;
    }

    /**
     * テキストを取得する
     * @return FlxText
     */
    public function getText():FlxText {
        return _txt;
    }

    /**
     * 開始時の座標に設定
     */
    public function resetOriginPosition():Void {
        setStart(_xorigin, _yorigin);
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // テキスト座標更新
        _txt.x = x + TEXT_OFS_X;
        _txt.y = y + TEXT_OFS_Y;
    }
}

/**
 * 状態
 */
private enum State {
    Standby; // 待機中
    Dragging; // ドラッグ中
    MsgWait; // メッセージ待ち
    Correct; // 正解
    CorrectBlink; // 正解時の点滅
}


/**
 * パネルをドラッグ＆ドロップする入力装置
 */
class DragPanelInputUI extends MenuUIBase {

    static inline var ANSWER_COLOR:Int = 0xFF5080FF;
    static inline var ANSWER_SIZE:Int = 68;
    static inline var ANSWER_X:Int = 16;
    static inline var ANSWER_Y:Int = 64;
    static inline var ANSWER_OFS_X:Int = 70;
    static inline var ANSWER_INVALID_ID:Int = -1;
    static inline var PANEL_NUM:Int = 4;
    static inline var HIT_OFS:Int = 2;

    var _id:Int = 0;
    var _cnt:Int = 0;
    var _time:Float = 0;
    var _state:State = State.Standby;
    var _panels:Array<DragPanelUI>;
    var _draggedPanel:DragPanelUI;
    var _answerHitList:Array<FlxSprite>;
    var _answers:Array<Int>;
    var _answer:String;
    var _result:Bool = false;
    var _backSpr:FlxSprite;

    /**
     * コンストラクタ
     */
    public function new(id:Int) {
        super();

        _id = id;

        // パネル情報を取得する
        var info = PanelDB.get(id);

        // 答えを保持
        _answer = info.answer;

        var ANSWER_NUM:Int = haxe.Utf8.length(_answer);
        trace('ANSWER_NUM: ${ANSWER_NUM} <- ${_answer}');

        // 答えの当たり判定
        _answerHitList = new Array<FlxSprite>();
        for(i in 0...ANSWER_NUM) {
            var px = ANSWER_X + (i * ANSWER_OFS_X);
            var py = ANSWER_Y;
            var spr = new FlxSprite(px, py);
            spr.ID = i; // 要素番号を保持する
            spr.makeGraphic(ANSWER_SIZE, ANSWER_SIZE, FlxColor.WHITE);
            _answerHitList.push(spr);
        }

        // 回答リスト
        _answers = new Array<Int>();
        for(i in 0...ANSWER_NUM) {
            _answers.push(ANSWER_INVALID_ID);
        }

        // パネル
        _panels = new Array<DragPanelUI>();
        var choices = info.choices;
        for(i in 0...choices.length) {
            var choice = choices[i];
            if(choice.on != null) {
                if(EscGlobal.flagCheck(choice.on.value) == false) {
                    // Onフラグが立っていないので非表示
                    continue;
                }
            }
            if(choice.off != null) {
                if(EscGlobal.flagCheck(choice.off.value) == true) {
                    // Offフラグが立っているので非表示
                    continue;
                }
            }

            var idx = _panels.length;
            var px = FlxG.width/2 + ((idx%PANEL_NUM)-(PANEL_NUM/2)) * ANSWER_OFS_X;
            var py = _answerHitList[0].y + _answerHitList[0].height;
            py += ANSWER_SIZE + Std.int(idx/PANEL_NUM) * ANSWER_OFS_X;
            var panel = new DragPanelUI(px, py, '${choice.letter}');
            panel.ID = _panels.length; // 要素番号を保持する
            _panels.push(panel);
        }

        {
            // 背景
            var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
            bg.color = FlxColor.BLACK;
            bg.alpha = 0.5;
            this.add(bg);
        }

        for(spr in _answerHitList) {
            this.add(spr);
        }

        for(panel in _panels) {
            this.add(panel);
            this.add(panel.getText());
        }

        // BACKボタン
        {
            var px = FlxG.width/2;
            var py = Const.getBottom();
            var spr = new FlxSprite(px, py, Resources.BTN_BACK_PATH);
            spr.x -= spr.width/2;
            spr.y -= spr.height * 1.5;
            _backSpr = spr;
            this.add(_backSpr);
        }
    }

    /**
     * 結果を取得する
     * @return Bool
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
        _time += elapsed;

        // 更新
        for(spr in _answerHitList) {
            spr.color = ANSWER_COLOR;
        }

        switch(_state) {
            case State.Standby:
                _updateStandby();
            case State.Dragging:
                _updateDragging();
            case State.MsgWait:
            case State.Correct:
                _updateCorrect();
            case State.CorrectBlink:
                _updateCorrectBlink();
        }
    }

    /**
     * 更新・待機
     */
    function _updateStandby():Void {

        if(FlxG.mouse.justPressed) {
            if(Utils.checkClickSprite(_backSpr)) {
                // OKボタンをクリックした
                kill();
                return;
            }
        }

        _draggedPanel = null;
        var id:Int = -1;
        for(panel in _panels) {
            if(panel.isDragged()) {
                if(panel.ID > id) {
                    // 優先して選択する
                    if(_draggedPanel != null) {
                        // ドラッグキャンセル
                        _draggedPanel.cancelToDrag();
                    }
                    _draggedPanel = panel;
                    id = panel.ID;
                    _state = State.Dragging;
                }
                else {
                    // 他のパネルを選択済み
                    panel.cancelToDrag();
                }
            }
        }

        if(_draggedPanel != null) {
            // 最前面に移動
            this.remove(_draggedPanel, true);
            this.remove(_draggedPanel.getText(), true);
            this.add(_draggedPanel);
            this.add(_draggedPanel.getText());
        }
    }

    /**
     * 更新・ドラッグ中
     */
    function _updateDragging():Void {

        // パネル点滅
        var ratio = Math.abs(Math.sin(_time * 8));
        _draggedPanel.color = FlxColor.interpolate(DragPanelUI.BG_COLOR, FlxColor.WHITE, ratio);

        // 置き場所判定
        var hitSpr:FlxSprite = _hitAnswer(_draggedPanel);
        if(hitSpr != null) {
            // 点滅する
            hitSpr.color = FlxColor.interpolate(ANSWER_COLOR, FlxColor.WHITE, ratio);
        }

        if(_draggedPanel.isJustReleased() == false) {
            // パネルを離していない
            return;
        }

        // 離したので元の色に戻す
        _draggedPanel.color = DragPanelUI.BG_COLOR;

        if(hitSpr == null) {
            // 置き場所の指定がない場合は最初の位置に戻る
            _draggedPanel.resetOriginPosition();
            for(i in 0..._answer.length) {
                if(_answers[i] == _draggedPanel.ID) {
                    _answers[i] = ANSWER_INVALID_ID; // 消しておく
                }
            }
        }
        else {
            // 答えの枠に配置する
            _moveHitSpr(_draggedPanel, hitSpr);

            var hitID    = hitSpr.ID;
            var panelID  = _draggedPanel.ID; // 配置するパネル番号
            var replacedPanel:DragPanelUI = null; // 置き換えられるパネル

            // 交換パネルチェック
            replacedPanel = _checkSwapPanel(hitSpr, _draggedPanel);
            for(i in 0..._answers.length) {
                if(_answers[i] == panelID) {
                    // 配置積みのものを移動した場合は元のを消す
                    _answers[i] = ANSWER_INVALID_ID;
                    if(replacedPanel != null) {
                        // 交換したパネルの番号を入れておく
                        _answers[i] = replacedPanel.ID;
                    }
                }
            }
            // 答えに反映する
            _answers[hitID] = panelID;
        }

        _draggedPanel.endWait();
        trace(_answers);

        if(_checkAnswer()) {
            // 正解
            trace("correct!");
            _result = true;
            _backSpr.exists = false; // 戻るボタンを非表示
            _state = State.Correct;
            for(panel in _panels) {
                panel.lock();
            }
        }
        else {
            // 不正解
            _state = State.Standby;
        }

    }

    /**
     * 更新・正解
     */
    function _updateCorrect():Void {
        for(panel in _panels) {
            if(panel.isEndReturn() == false) {
                return; // 移動中のパネルがある
            }
        }

        // 点滅処理へ
        _cnt = 0;
        _state = State.CorrectBlink;
    }

    /**
     * 更新・正解時の点滅
     */
    function _updateCorrectBlink():Void {
        for(i in _answers) {
            var panel = _panels[i];
            var ratio = Math.abs(Math.sin(_time * 8));
            panel.color = FlxColor.interpolate(DragPanelUI.BG_COLOR, FlxColor.WHITE, ratio);
        }

        _cnt++;
        if(_cnt > 60) {
            // おしまい
            kill();
        }
    }

    function _checkAnswer():Bool {
        // 入力した文字を判定する
        var str:String = "";
        for(i in 0..._answers.length) {
            if(_answers[i] == ANSWER_INVALID_ID) {
                // 指定なしの項目があれば必ず不正解
                str = "";
                break;
            }
            var answerID = _answers[i];
            str += _panels[answerID].getText().text;
        }

        trace(_answer, str);
        return _answer == str;
    }

    /**
     * 答えエリアとの当たり判定
     * @return FlxSprite
     */
    function _hitAnswer(panel:DraggableUI):FlxSprite {
        var ret:FlxSprite = null;
        var distance:Float = 10000000;
        for(spr in _answerHitList) {
            FlxG.overlap(panel, spr, function(a:DragPanelUI, b:FlxSprite) {
                // 当たり
                var d = FlxMath.distanceBetween(a, b);
                if(d > distance) {
                    return; // より近い当たりがあるので保持しない
                }

                // 結果を保持
                distance = d;
                ret = b;
            });
        }

        return ret;
    }

    /**
     * 交換処理
     * @param hitSpr 配置する場所Sprite
     * @param panel 配置するパネル
     * @return DragPanelUI 交換するパネル
     */
    function _checkSwapPanel(hitSpr:FlxSprite, panel:DragPanelUI):DragPanelUI {
        var replacedPanel:DragPanelUI = null;
        var hitID    = hitSpr.ID;
        var answerID = _answers[hitID];
        var panelID  = panel.ID; // 配置するパネル番号

        if(panelID == answerID) {
            // 同じ場所に置く場合は交換処理は発生しない
            return null;
        }
        
        // 違う場所に配置する
        if(answerID == ANSWER_INVALID_ID) {
            // 配置先が空なので交換処理は発生しない
            return null;
        }

        // 配置済みのパネルを元の位置に戻す
        replacedPanel = _panels[answerID];
        var isReset = true;
        for(i in 0..._answers.length) {
            if(_answers[i] == panelID) {
                // 移動前の場所
                isReset = false;
                // 配置済みのパネルの位置を交換する
                var hit = _answerHitList[i];
                _moveHitSpr(replacedPanel, hit);
            }
        }
        if(isReset) {
            // 位置のリセットが必要
            replacedPanel.resetOriginPosition();
            for(i in 0..._answers.length) {
                if(_answers[i] == replacedPanel.ID) {
                    _answers[i] = ANSWER_INVALID_ID; // 消しておく
                }
            }
        }

        return replacedPanel;
    }

    /**
     * パネルをヒットエリアに配置する
     * @param panel 
     * @param hitSpr 
     */
    function _moveHitSpr(panel:DragPanelUI, hitSpr:FlxSprite):Void {
        panel.setStart(hitSpr.x + HIT_OFS, hitSpr.y + HIT_OFS);
    }
}