package save;

import flixel.util.FlxSave;
import esc.EscGlobal;

/**
 * ゲームデータ管理
 */
class GameData {

    static inline var SAVE_NAME:String = "GAMEDATA";

    /**
     * 初期化
     */
    public static function init():Void {
        if(exists()) {
            // すでに存在している場合は何もしない
            return;
        }

        // ■新規作成
    }

    /**
     * セーブデータが存在するかどうか
     */
    public static function exists():Bool {
        var saveutil = _bind();
        if(saveutil.data == null) {
            // データがない
            return false;
        }

        return true;
    }

    /**
     * セーブ実行
     */
    public static function save():Void {
        var d = _bind();
        d.data.flags = EscGlobal.getFlags();
        d.data.vals  = EscGlobal.getVals();
        d.data.items = new Array<Int>();
        for(state in EscGlobal.getItems()) {
            var v = EscGlobal.itemStateToInt(state);
            d.data.items.push(v);
        }
        d.data.scene = EscGlobal.getNowSceneID();

        d.flush();

        trace("save done.");
    }

    /**
     * ロード実行
     */
    public static function load():Bool {
        var d = _bind();
        if(d.data == null) {
            return false;
        }

        _loadFlags(d.data.flags);
        _loadVals(d.data.vals);
        _loadItems(d.data.items);

        EscGlobal.setNowSceneID(d.data.scene);

        trace("load done.");

        return true;
    }

    static function _loadFlags(flags:Array<Bool>):Void {
        for(i in 0...flags.length) {
            EscGlobal.flagSet(i, flags[i]);
        }
    }
    static function _loadVals(vals:Array<Int>):Void {
        for(i in 0...vals.length) {
            EscGlobal.valSet(i, vals[i]);
        }
    }
    static function _loadItems(items:Array<Int>):Void {
        for(i in 0...items.length) {
            var state = EscGlobal.intToItemState(items[i]);
            EscGlobal.itemSetState(i, state);
        }
    }

    static function _bind():FlxSave {
        var saveutil = new FlxSave();
        saveutil.bind(SAVE_NAME);
        return saveutil;
    }
}