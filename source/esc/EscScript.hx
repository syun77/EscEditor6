package esc;

import flixel.group.FlxSpriteGroup;
import ui.NumberInputSubState;
import lib.AdvScript;

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
class EscScript extends FlxSpriteGroup {
    var _state:State = State.Standby;
    var _script:AdvScript;
    var _wait:Float = 0;
    var _isLog:Bool = false;

    /**
     * コンストラクタ
     */
    public function new() {
        super();
        _init();
    }

    /**
     * 初期化
     */
    function _init():Void {
        _wait = 0;
    }

    /*
    function _cmdNumberInput(cmd:EscCommand):CmdRet {
        var idx = cmd.paramInt(0);
        var digit = cmd.paramInt(1);
        EscGlobal.numberInputSet(idx, digit);
        var editor = PlayState.getEditor();
        if(editor != null) {
            editor.openSubState(new NumberInputSubState());
        }
        return CmdRet.Yield;
    }
    function _cmdWait(cmd:EscCommand):CmdRet {
        var wait = cmd.paramFloat(0);
        _wait = wait;
        _state = State.Wait;
        return CmdRet.Yield;
    }
    function _cmdJump(cmd:EscCommand):CmdRet {
        var sceneID = cmd.paramInt(0);
        EscGlobal.setNextSceneID(sceneID);
        return CmdRet.Exit;
    }
    */

    /**
     * 実行を終了したかどうか
     */
    public function isEnd():Bool {
        return _state == State.Standby;
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        switch(_state) {
            case State.Standby:
                // 何もしない
            case State.Execute:
                _updateExecute(elapsed);
            case State.MsgWait:
            case State.KeyWait:
        }
    }

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
    public function execute(filepath:String):Void {
        _init();

        // 実行
        var tbl = [
            "MSG"       => _MSG,
            "NUM_INPUT" => _NUM_INPUT,
        ];
        _script = new AdvScript(tbl, filepath);
        _register();
        _script.setLog(true);
        _isLog = true;
        _state = State.Execute;
    }
    function _MSG(param:Array<String>):Int {
        _log('[SCRIPT] MSG');
        var type = Std.parseInt(param[0]);
        var msg = param[1];
        var r = ~/\$V\[(\d)\]/;
        if(r.match(msg)) {
            // $V[n] を変数に置き換え
            var idx = Std.parseInt(r.matched(1));
            var val = EscGlobal.valGet(idx);
            msg = r.replace(msg, '${val}');
        }
        
        PlayState.getInfomationUI().start(msg, 3);

        return AdvScript.RET_CONTINUE;
    }
    function _NUM_INPUT(param:Array<String>):Int {
        _log('[SCRIPT] NUM_INPUT');
        var idx = _script.popStack();
        var digit = _script.popStack();
        EscGlobal.numberInputSet(idx, digit);
        var editor = PlayState.getEditor();
        if(editor != null) {
            editor.openSubState(new NumberInputSubState());
        }
        return AdvScript.RET_YIELD;
    }

    /**
    * ログの出力
    **/
    function _log(msg:String):Void {
        if(_isLog) {
            trace(msg);
        }
    }

    /**
     * 登録
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

}