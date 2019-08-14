package esc;

/**
 * アイテム所持状態
 */
private enum ItemState {
    None; // 未所持
    Has;  // 所持している
    Del;  // 持っていたけど削除した
}

/**
 * グローバル変数管理
 */
class EscGlobal {
    // --------------------------------------------------------------------
    // ■定数
    // 最大数
    public static inline var MAX_FLAG:Int = 100; // フラグの最大数 (0無効)
    public static inline var MAX_VAL:Int  = 100; // 変数の最大数
    public static inline var MAX_ITEM:Int = 32;  // アイテムの最大数

    // 無効な値
    public static inline var ITEM_INVALID:Int  = 0; // 無効なアイテムID
    public static inline var SCENE_INVALID:Int = 0; // 無効なシーンID

    // システム変数
    public static inline var VAL_ITEM:Int = 0; // 変数0: 装備しているアイテム番号を保持する
    public static inline var VAL_RET:Int = 1; // 変数1: リターンコード。戻り値はこの変数に保持する
    public static inline var VAL_2:Int = 2;
    public static inline var VAL_3:Int = 3;
    public static inline var VAL_4:Int = 4;
    public static inline var VAL_5:Int = 5;
    public static inline var VAL_6:Int = 6;
    public static inline var VAL_7:Int = 7;
    public static inline var VAL_8:Int = 8;
    public static inline var VAL_9:Int = 9;

    // --------------------------------------------------------------------
    // ■変数
    // フラグ
    static var _flags:Array<Bool>;
    // 変数
    static var _vals:Array<Int>;
    // アイテム所持状態
    static var _items:Array<ItemState>;
    // アイテム名
    static var _itemNames:Array<String>;

    // 次のシーン
    static var _nextScene:Int = SCENE_INVALID;

    // 数値入力情報
    static var _numberInputIdx:Int = 0; // 受け渡しする変数番号
    static var _numberInputDigit:Int = 0; // 受渡しする桁数

    // 編集モードかどうか
    static var _isEdit:Bool = false;

    // --------------------------------------------------------------------
    // ■関数
    /**
     * 初期化
     */
    public static function init():Void {
        _flags = new Array<Bool>();
        for(i in 0...MAX_FLAG) {
            _flags.push(false);
        }
        _vals = new Array<Int>();
        for(i in 0...MAX_VAL) {
            _vals.push(0);
        }
        _items = new Array<ItemState>();
        for(i in 0...MAX_ITEM) {
            _items.push(ItemState.None);
        }
        _itemNames = [
            "", // 0
            "黄色のカギ", // 1
            "", // 2
            "", // 3
            "", // 4
            "", // 5
            "", // 6
            "", // 7
            "", // 8
            "", // 9
            "", // 10
        ];
    }

    public static function setNextSceneID(sceneID:Int):Void {
        _nextScene = sceneID;
    }
    public static function getNextSceneID():Int {
        return _nextScene;
    }
    public static function hasNextSceneID():Bool {
        return _nextScene != SCENE_INVALID;
    }
    public static function clearNextSceneID():Void {
        _nextScene = SCENE_INVALID;
    }

    /**
     * フラグ
     */
    public static function flagCheck(idx:Int):Bool {
        return _flags[idx];
    }
    public static function flagSet(idx:Int, b:Bool):Void {
        _flags[idx] = b;
    }

    /**
     * 変数
     */
    public static function valGet(idx:Int):Int {
        return _vals[idx];
    }
    public static function valSet(idx:Int, val:Int):Void {
        _vals[idx] = val;
    }
    public static function valAdd(idx:Int, val:Int):Void {
        _vals[idx] += val;
    }

    /**
     * リターンコード
     */
    public static function retGet():Int {
        return valGet(VAL_RET);
    }
    public static function retSet(v:Int):Void {
        valSet(VAL_RET, v);
    }

    /**
     * アイテム
     */
    public static function itemAdd(idx:Int):Bool {
        if(itemHas(idx)) {
            return false; // すでに所持している
        }
        _items[idx] = ItemState.Has;
        // 獲得アイテムを自動で装備する
        itemEquip(idx);
        return true;
    }
    public static function itemHas(idx:Int):Bool {
        return _items[idx] == ItemState.Has;
    }
    public static function itemCheck(idx:Int):Bool {
        return valGet(VAL_ITEM) == idx; // 装備しているアイテムかどうか
    }
    public static function itemDel(idx:Int):Bool {
        if(itemHas(idx)) {
            _items[idx] = ItemState.Del;
            if(itemCheck(idx)) {
                // 装備していたら外す
                valSet(VAL_ITEM, ITEM_INVALID);
            }
            return true;
        }
        return false; // 所持していないアイテム
    }
    public static function itemEquip(idx:Int):Bool {
        if(itemHas(idx)) {
            valSet(VAL_ITEM, idx);
            return true;
        }
        return false;
    }
    // 所持アイテム数をカウントする
    public static function itemCount():Int {
        var ret:Int = 0;
        for(item in _items) {
            if(item == ItemState.Has) {
                ret++;
            }
        }
        return ret;
    }
    // アイテム名を取得する
    public static function itemName(idx:Int):String {
        return _itemNames[idx];
    }
    // アイテムが全てNoneかどうか
    public static function itemAllNone():Bool {
        for(item in _items) {
            if(item != ItemState.None) {
                return false;
            }
        }
        // 全てNone
        return true;
    }

    /**
     * 数値入力
     */
    public static function numberInputSet(idx:Int, digit:Int):Void {
        _numberInputIdx = idx;
        _numberInputDigit = digit;
    }
    public static function numberInputGetIdx():Int {
        return _numberInputIdx;
    }
    public static function numberInputGetDigit():Int {
        return _numberInputDigit;
    }

    // デバッグ機能
    public static function setEdit(b:Bool):Void {
        _isEdit = b;
    }
    public static function isEdit():Bool {
        return _isEdit;
    }
}