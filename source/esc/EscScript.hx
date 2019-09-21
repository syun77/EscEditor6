package esc;

import ui.message.MessageUI;
import lib.AdvScript;
import state.PlayState;
import dat.ItemDB;
import ui.SelectUI.SelectParam;

/**
 * 状態
 */
private enum State {
    Standby; // 待機中
    Execute; // 実行中
    KeyWait; // キー入力待ち
    MsgWait; // メッセージ表示待ち
}

/**
 * スクリプト管理
 */
class EscScript {
    
    var _state:State = State.Standby;
    var _script:AdvScript;
    var _wait:Float = 0;
    var _isLog:Bool = false;
    var _isCompleted:Bool = false; // ゲームクリアフラグ

    // 選択肢
    var _selectQuestion:String;

    /**
     * コンストラクタ
     */
    public function new() {
        _init();
    }

    /**
     * 初期化
     */
    function _init():Void {
        _wait = 0;
    }

    /**
     * 実行を終了したかどうか
     */
    public function isEnd():Bool {
        return _state == State.Standby;
    }

    /**
     * ゲームをクリアしたかどうか
     */
    public function isCompleted():Bool {
        return _isCompleted;
    }

    /**
     * 更新
     */
    public function update(elapsed:Float):Void {
        switch(_state) {
            case State.Standby:
                // 何もしない
            case State.Execute:
                _updateExecute(elapsed);
            case State.MsgWait:
            case State.KeyWait:
        }
    }

    /**
     * 更新・スクリプト実行
     * @param elapsed 経過時間
     */
    function _updateExecute(elapsed:Float):Void {
        if(_wait > 0) {
            // 実行停止中
            _wait -= elapsed;
            return;
        }

        _script.update();
        if(_script.isEnd()) {
            // 実行終了
            _state = State.Standby;
        }
    }

    /**
     * 実行
     */
    public function execute(filepath:String, funcname:String=null):Bool {
        _init();

        // 実行
        var tbl = [
            "WAIT"       => _WAIT,
            "MSG"        => _MSG,
            "NUM_INPUT"  => _NUM_INPUT,
            "PIC_INPUT"  => _PIC_INPUT,
            "PNL_INPUT"  => _PNL_INPUT,
            "KANA_INPUT" => _KANA_INPUT,
            "JUMP"       => _JUMP,
            "ITEM_ADD"   => _ITEM_ADD,
            "ITEM_HAS"   => _ITEM_HAS,
            "ITEM_DEL"   => _ITEM_DEL,
            "ITEM_CHK"   => _ITEM_CHK,
            "CRAFT_CHK"  => _CRAFT_CHK,
            "COMPLETE"   => _COMPLETE,
            "SEL"        => _SEL,
            "SEL_ANS"    => _SEL_ANS,
            "SEL_GOTO"   => _SEL_GOTO,
            "DRAW_OBJ"   => _DRAW_OBJ,
            "ERASE_OBJ"  => _ERASE_OBJ,
        ];
        _script = new AdvScript(tbl, filepath);
        _register();
        _script.setLog(true);
        _isLog = true;

        if(funcname != null) {
            // 直接関数を呼び出す
            if(funcname == "init") {
                // "init" は事前検索をする
                if(_script.searchFunction(funcname) == false) {
                    // 存在しない
                    return false;
                }
            }
            _script.jumpFunction(funcname);
        }

        _state = State.Execute;
        return true;
    }
    function _WAIT(param:Array<String>):Int {
        _log('WAIT');
        var sec = _script.popStack();
        _wait = sec;
        return AdvScript.RET_YIELD;
    }
    function _MSG(param:Array<String>):Int {
        _log('MSG {${param[0]}} ${param[1]}');
        return _message(param, false);
    }
    function _NUM_INPUT(param:Array<String>):Int {
        _log('NUM_INPUT');
        var idx = _script.popStack();
        var digit = _script.popStack();
        EscGlobal.numberInputSet(idx, digit);
        var editor = PlayState.getEditor();
        if(editor != null) {
            editor.openNumberInput();
        }
        return AdvScript.RET_YIELD;
    }
    function _PIC_INPUT(param:Array<String>):Int {
        _log('PIC_INPUT');
        var pic = _script.popStack();
        var idx = _script.popStack();
        var digit = _script.popStack();
        EscGlobal.numberInputSet(idx, digit);
        var editor = PlayState.getEditor();
        if(editor != null) {
            editor.openPictureInput(pic, digit);
        }
        return AdvScript.RET_YIELD;
    }
    function _PNL_INPUT(param:Array<String>):Int {
        _log('PNL_INPUT');
        var panelID = _script.popStack();
        var editor = PlayState.getEditor();
        if(editor != null) {
            editor.openPanelInput(panelID);
        }
        return AdvScript.RET_YIELD;
    }
    function _KANA_INPUT(param:Array<String>):Int {
        _log('KANA_INPUT');
        var kanaID = _script.popStack();
        var editor = PlayState.getEditor();
        if(editor != null) {
            editor.openKanaInput(kanaID);
        }
        return AdvScript.RET_YIELD;
    }
    function _JUMP(param:Array<String>):Int {
        var sceneID = _script.popStack();
        _log('SCENE JUMP -> ${sceneID}');
        EscGlobal.setNextSceneID(sceneID);
        return AdvScript.RET_EXIT;
    }
    function _ITEM_ADD(param:Array<String>):Int {
        _log('ITEM_ADD');
        var itemID = _script.popStack();
        EscGlobal.itemAdd(itemID);

        var item = ItemDB.get(itemID);
        if(item.flag != null) {
            // 獲得フラグをONにする
            EscGlobal.flagSet(item.flag.value, true);
        }

        // アイテム入手メッセージ表示
        var msg = '「${item.name}」を手に入れた';
        PlayState.getInformationUI().start(msg, 3);
        return AdvScript.RET_YIELD;
    }
    function _ITEM_HAS(param:Array<String>):Int {
        _log('ITEM_HAS');
        var itemID = _script.popStack();
        if(EscGlobal.itemHas(itemID)) {
            EscGlobal.retSet(1);
        }
        else {
            EscGlobal.retSet(0);
        }
        return AdvScript.RET_CONTINUE;
    }
    function _ITEM_DEL(param:Array<String>):Int {
        var itemID = _script.popStack();
        _log('ITEM_DEL ${ItemDB.get(itemID).name}');
        // アイテムを削除
        EscGlobal.itemDel(itemID);
        /*
        if(EscGlobal.itemDel(itemID)) {
            EscGlobal.retSet(1);
        }
        else {
            EscGlobal.retSet(0);
        }
        */
        return AdvScript.RET_CONTINUE;
    }
    function _ITEM_CHK(param:Array<String>):Int {
        _log('ITEM_CHK');
        var itemID = _script.popStack();
        if(EscGlobal.itemCheck(itemID)) {
            EscGlobal.retSet(1);
        }
        else {
            EscGlobal.retSet(0);
        }
        return AdvScript.RET_CONTINUE;
    }
    function _CRAFT_CHK(param:Array<String>):Int {
        var itemID1 = _script.popStack();
        var itemID2 = _script.popStack();
        var ret = ItemDB.checkCraft(itemID1, itemID2);
        EscGlobal.retSet(ret);
        return AdvScript.RET_CONTINUE;
    }
    function _COMPLETE(param:Array<String>):Int {
        _log('COMPLETE');
        _isCompleted = true;
        return AdvScript.RET_EXIT;
    }
    function _SEL(param:Array<String>):Int {
        if(_isLog) {
            trace("[SCRIPT] SEL");
        }

        var cnt = Std.parseInt(param[0]);
        var ret = AdvScript.RET_CONTINUE;
        for(i in 0...cnt) {
            var mode = 0;
            if(i == cnt - 1) {
                mode = 1; // 改ページ
            }
            var arr = ['${mode}', param[i + 1]];
            ret = _message(arr, true);
        }

        return ret;
    }

    function _SEL_ANS(param:Array<String>):Int {
        if(_isLog) {
            trace("[SCRIPT] SEL_ANS");
        }

        param.shift(); // 最初の値は選択肢の数なので捨てる
        var p = new SelectParam();
        p.choices = param;
        PlayState.getEditor().openSelect(p);

        return AdvScript.RET_YIELD;
    }

    function _SEL_GOTO(param:Array<String>):Int {
        if(_isLog) {
            trace("[SCRIPT] SEL_GOTO");
        }

        var idx = EscGlobal.retGet();
        if(idx < 0 || param.length <= idx) {
            trace('[SCRIPT] Error invalid select idx(${idx})'); // 選んだ選択肢番号が正しくない
        }
        else {
            var address = Std.parseInt(param[EscGlobal.retGet()]);
            _script.jumpAddress(address);
        }

        return AdvScript.RET_CONTINUE;
    }

    function _DRAW_OBJ(param:Array<String>):Int {
        var objID = _script.popStack();
        if(_isLog) {
            trace('[SCRIPT] DRAW_OBJ(${objID})');
        }

        PlayState.getEditor().showObj(objID);

        return AdvScript.RET_CONTINUE;
    }
    
    function _ERASE_OBJ(param:Array<String>):Int {
        if(_isLog) {
            trace("[SCRIPT] ERASE_OBJ");
        }
        
        PlayState.getEditor().hideObj();

        return AdvScript.RET_CONTINUE;
    }

    /**
    * ログの出力
    **/
    function _log(msg:String):Void {
        if(_isLog) {
            trace('[SCRIPT] ${msg}');
        }
    }

    /**
     * メッセージを処理する
     * @param param 
     * @return Int スクリプトの戻り値
     */
    function _message(param:Array<String>, isQuestion:Bool):Int {
        var type = Std.parseInt(param[0]);
        var msg = param[1];
        var r = ~/\$(\d+)/;
        if(r.match(msg)) {
            // $V[n] を変数に置き換え
            var idx = Std.parseInt(r.matched(1));
            var val = EscGlobal.valGet(idx);
            msg = r.replace(msg, '${val}');
        }
        
        switch(type) {
        case 1:
            // 改ページ
            if(isQuestion) {
                // 問題文の場合は消さない
                PlayState.getEditor().addMessage(msg, MessageUI.PF_MODE_KEEP);
            }
            else {
                PlayState.getEditor().addMessage(msg, MessageUI.PF_MODE_WAIT);
            }
            return AdvScript.RET_YIELD;
        case 9:
            // インフォメーション表示
            PlayState.getInformationUI().start(msg, 3);
            return AdvScript.RET_CONTINUE;
        default:
            // メッセージテキスト
            PlayState.getEditor().addMessage(msg);
            return AdvScript.RET_CONTINUE;
        }
    }

    /**
     * コールバック関数を登録
     */
    function _register():Void {
        // フラグ
        _script.funcLengthBit = function() { return EscGlobal.MAX_FLAG; }
        _script.funcSetBit = EscGlobal.flagSet;
        _script.funcGetBit = EscGlobal.flagCheck;

        // 変数
        _script.funcLengthVar = function() { return EscGlobal.MAX_VAL; }
        _script.funcSetVar = EscGlobal.valSet;
        _script.funcGetVar = EscGlobal.valGet;
    }

    /**
     * 選択肢の開始
     * @param strList 
     */
    function _selectChoice(strList:Array<String>):Void {
        var param = new SelectParam();
        param.choices = strList;
        PlayState.getEditor().openSelect(param);
    }

}