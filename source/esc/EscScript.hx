package esc;

import flixel.group.FlxSpriteGroup;
import hscript.Parser;
import hscript.Interp;

/**
 * 状態
 */
private enum State {
    Standby; // 待機中
    Execute; // 実行中
    Wait;    // 一定時間待つ
    KeyWait; // キー入力待ち
    MsgWait; // メッセージ表示待ち
}

/**
 * コマンド種別
 */
private enum Cmd {
    BitOn;      // フラグを立てる
    BitOff;     // フラグを下げる
    IfGoto;     // フラグが立っていたら指定のラベルまでジャンプする
    Label;      // ラベルの定義
    Jump;       // シーンジャンプ
    Infomation; // インフォメーションテキスト表示
    Message;    // メッセージ表示
    Wait;       // 一定時間待つ
    Other;      // その他
}

/**
 * コマンドの戻り値
 */
private enum CmdRet {
    Continue;  // 続行
    Yield;     // 制御を返す
    Exit;      // 終了
}

class EscCommand {
    public var cmd:Cmd; // コマンド種別
    public var params:Array<Dynamic>; // パラメータ
    public var func:String -> Void; // 拡張パラメータ名

    public function new(cmd:Cmd, param:Dynamic=null) {
        this.cmd = cmd;
        this.func = null;
        params = new Array<Dynamic>();        
        if(param != null) {
            add(param);
        }
    }
    public function add(param:Dynamic):Void {
        params.push(param);
    }
    public function paramInt(idx:Int):Int {
        return cast(params[idx], Int);
    }
    public function paramString(idx:Int):String {
        return cast(params[idx], String);
    }
    public function paramFloat(idx:Int):Float {
        return cast(params[idx], Float);
    }

    public function dump():Void {
        trace(cmd);
        for(param in params) {
            trace(param);
        }
        trace(func);
    }
}

/**
 * スクリプト管理
 */
class EscScript extends FlxSpriteGroup {
    var _state:State = State.Standby;
    var _interp:Interp = null;

    var _cmdList:List<EscCommand>;
    var _cmdTbl:Map<Cmd,EscCommand -> CmdRet>;

    var _lastLabel:String = null;
    var _jumpLabel:String = null;
    var _wait:Float = 0;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        _cmdList = new List<EscCommand>();
        _cmdTbl = [
            Cmd.BitOn      => _cmdBitOn,
            Cmd.BitOff     => _cmdBitOff,
            Cmd.IfGoto     => _cmdIfGoto,
            Cmd.Label      => _cmdLabel,
            Cmd.Message    => _cmdMessage,
            Cmd.Wait       => _cmdWait,
            Cmd.Infomation => _cmdInfomation,
            Cmd.Jump       => _cmdJump,
            Cmd.Other      => _cmdOther,
        ];
    }

    function _cmdBitOn(cmd:EscCommand):CmdRet {
        var idx = cmd.paramInt(0);
        EscGlobal.flagSet(idx, true);
        return CmdRet.Continue;
    }
    function _cmdBitOff(cmd:EscCommand):CmdRet {
        var idx = cmd.paramInt(0);
        EscGlobal.flagSet(idx, false);
        return CmdRet.Continue;
    }
    function _cmdIfGoto(cmd:EscCommand):CmdRet {
        var idx = cmd.paramInt(0);
        var label = cmd.paramString(1);
        if(EscGlobal.flagCheck(idx)) {
            // ラベルジャンプする
            _jumpLabel = label;
        }
        return CmdRet.Continue;
    }
    function _cmdLabel(cmd:EscCommand):CmdRet {
        var label = cmd.paramString(0);
        _lastLabel = label;
        return CmdRet.Continue;
    }
    function _cmdMessage(cmd:EscCommand):CmdRet {
        var msg = cmd.paramString(0);
        return CmdRet.Continue;
    }
    function _cmdInfomation(cmd:EscCommand):CmdRet {
        var msg = cmd.paramString(0);
        PlayState.getInfomationUI().start(msg, 3);
        return CmdRet.Continue;
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
    function _cmdOther(cmd:EscCommand):CmdRet {
        var msg = cmd.paramString(0);
        cmd.func(msg);
        return CmdRet.Continue;
    }

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
                _updateExecute();
            case State.Wait:
                _updateWait(elapsed);
            case State.MsgWait:
            case State.KeyWait:
        }
    }

    function _updateExecute():Void {
        while(true) {
            if(_cmdList.length <= 0) {
                // おしまい
                _state = State.Standby;
                return;
            }
            var cmd = _cmdList.pop();
            if(_jumpLabel != null) {
                if(_jumpLabel != _lastLabel) {
                    // ラベルが一致しない
                    continue;
                }
                // ラベルジャンプ終了
                _jumpLabel = null;
                _lastLabel = null;
            }

            var func = _cmdTbl[cmd.cmd];
            var ret = func(cmd);
            switch(ret) {
                case CmdRet.Continue:
                    // 続行
                case CmdRet.Yield:
                    // 制御を返す
                    return;
                case CmdRet.Exit:
                    // 終了
                    _state = State.Standby;
                    return;
            }
        }
    }

    function _updateWait(elapsed:Float):Void {
        _wait -= elapsed;
        if(_wait < 0) {
            _wait = 0;
            _state = State.Execute;
        }
    }

    /**
     * 実行
     */
    public function execute(str:String, tbl:Map<String,Dynamic>):Void {
        var parser = new Parser();
        var program = parser.parseString(str);
        _interp = new Interp();
        // 関数登録
        if(tbl != null) {
            for(key in tbl.keys()) {
                _register(key, function(msg:String) {
                    _add(Cmd.Other, msg).func = tbl[key];
                });
            }
        }
        _registers();

        // 実行
        var func = _interp.execute(program);
        func();

        _interp = null;

        _state = State.Execute;
    }

    /**
     * 変数/関数を登録する
     */
    function _registers():Void {
        _register("BITON",  function(idx:Int)    { _add(Cmd.BitOn, idx); } );
        _register("BITOFF", function(idx:Int)    { _add(Cmd.BitOff, idx); } );
        _register("IF_GOTO", function(idx:Int, label:String) { _add(Cmd.IfGoto, idx).add(label); } );
        _register("JUMP",   function(idx:Int)    { _add(Cmd.Jump, idx); } );
        _register("MSG",    function(msg:String) { _add(Cmd.Message, msg); } );
        _register("WAIT",   function(time:Float) { _add(Cmd.Wait, time); } );
        _register("NOTICE", function(msg:String) { _add(Cmd.Infomation, msg); });
    }
    function _register(key:String, variable:Dynamic):Void {
        _interp.variables.set(key, variable);
    }

    /**
     * コマンドの追加
     */
    function _add(cmd:Cmd, param:Dynamic=null):EscCommand {
        var command = new EscCommand(cmd, param);
        _cmdList.add(command);
        return command;
    }
}