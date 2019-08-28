package ui;

import ui.MenuUIBase;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import ui.DraggableUI;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.text.FlxText;

class DragPanelUI extends DraggableUI {
    static inline var SIZE:Int = 64;

    static inline var BG_COLOR:Int = FlxColor.GRAY;
    static inline var TEXT_COLOR:Int = FlxColor.WHITE;
    static inline var TEXT_OUTLINE_COLOR:Int = FlxColor.BLACK;
    static inline var TEXT_OFS_X:Int = -2;
    static inline var TEXT_OFS_Y:Int = -4;

    var _txt:FlxText;
    var _xorigin:Float = 0;
    var _yorigin:Float = 0;

    /**
     * コンストラクタ
     * @param px 
     * @param py 
     */
    public function new(px:Float, py:Float, str:String) {
        super(px, py);
        makeGraphic(64, 64, FlxColor.WHITE);
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
    Standby;
    Dragging;
    MsgWait;
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
    static inline var HIT_OFS:Int = 2;

    var _time:Float = 0;
    var _state:State = State.Standby;
    var _panels:Array<DragPanelUI>;
    var _draggedPanel:DragPanelUI;
    var _answerHitList:Array<FlxSprite>;
    var _answers:Array<Int>;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        var ANSWER_NUM:Int = 5;

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
        for(i in 0...8) {
            var px = FlxG.random.float(64, FlxG.width-64);
            var py = FlxG.random.float(64, FlxG.height-64);
            var panel = new DragPanelUI(px, py, '${i}');
            panel.ID = i; // 要素番号を保持する
            _panels.push(panel);
        }

        for(spr in _answerHitList) {
            this.add(spr);
        }

        for(panel in _panels) {
            this.add(panel);
            this.add(panel.getText());
        }
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _time++;

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
        }
    }

    /**
     * 更新・待機
     */
    function _updateStandby():Void {
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

        // 置き場所判定
        var hitSpr:FlxSprite = _hitAnswer(_draggedPanel);
        if(hitSpr != null) {
            // 点滅する
            var ratio = Math.abs(Math.sin(_time * 0.2));
            hitSpr.color = FlxColor.interpolate(ANSWER_COLOR, FlxColor.WHITE, ratio);
        }

        if(_draggedPanel.isJustReleased() == false) {
            // パネルを離していない
            return;
        }

        if(hitSpr == null) {
            // 置き場所の指定がない場合は最初の位置に戻る
            _draggedPanel.resetOriginPosition();
        }
        else {
            // 答えの枠に配置する
            _moveHitSpr(_draggedPanel, hitSpr);

            var hitID    = hitSpr.ID;
            var panelID  = _draggedPanel.ID; // 配置するパネル番号
            var replacedPanel:DragPanelUI = null; // 置き換えられるパネル

            // 交換パネルチェック
            replacedPanel = _checkSwapPanel(hitSpr, _draggedPanel);
            trace('add: ${_draggedPanel.ID}');
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
            trace(_answers);
        }

        _draggedPanel.endWait();
        _state = State.Standby;

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
                trace('swap: ${replacedPanel.ID} -> ${i}');
                var hit = _answerHitList[i];
                _moveHitSpr(replacedPanel, hit);
            }
        }
        if(isReset) {
            // 位置のリセットが必要
            replacedPanel.resetOriginPosition();
            trace('remove: ${answerID}');
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