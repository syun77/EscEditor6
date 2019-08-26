package esc;

/**
 * アイテム所持状態
 */
enum ItemState {
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
    public static inline var START_SCENE_ID:Int = 1;
    // 最大数
    public static inline var MAX_FLAG:Int = 100; // フラグの最大数 (0無効)
    public static inline var MAX_VAL:Int  = 100; // 変数の最大数
    public static inline var MAX_ITEM:Int = 32;  // アイテムの最大数

    // 無効な値
    public static inline var ITEM_INVALID:Int  = 0; // 無効なアイテムID
    public static inline var SCENE_INVALID:Int = 0; // 無効なシーンID

    // --------------------------------------------------------------------
    // ■変数
    // フラグ
    static var _flags:Array<Bool>;
    // 変数
    static var _vals:Array<Int>;
    // アイテム所持状態
    static var _items:Array<ItemState>;

    // 現在のシーン
    static var _nowScene:Int = 1;
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

        // 開始シーンを設定
        _nowScene = START_SCENE_ID;
        _nextScene = SCENE_INVALID;

        _isEdit = false;
    }

    public static function getFlags():Array<Bool> {
        return _flags;
    }
    public static function getVals():Array<Int> {
        return _vals;
    }
    public static function getItems():Array<ItemState> {
        return _items;
    }

    public static function setNowSceneID(sceneID:Int):Void {
        _nowScene = sceneID;
    }
    public static function getNowSceneID():Int {
        return _nowScene;
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
        return valGet(EscVar.RET);
    }
    public static function retSet(v:Int):Void {
        valSet(EscVar.RET, v);
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
        return valGet(EscVar.ITEM) == idx; // 装備しているアイテムかどうか
    }
    public static function itemDel(idx:Int):Bool {
        if(itemHas(idx)) {
            _items[idx] = ItemState.Del;
            if(itemCheck(idx)) {
                // 装備していたら外す
                valSet(EscVar.ITEM, ITEM_INVALID);
            }
            return true;
        }
        return false; // 所持していないアイテム
    }
    public static function itemRemove(idx:Int):Bool {
        // まずは削除
        if(itemDel(idx)) {
            _items[idx] = ItemState.None;   
            return true;
        }
        return false;
    }
    public static function itemEquip(idx:Int):Bool {
        if(itemHas(idx)) {
            valSet(EscVar.ITEM, idx);
            return true;
        }
        return false;
    }
    public static function itemEquipGetID():Int {
        return valGet(EscVar.ITEM);
    }
    public static function itemGetState(idx:Int):ItemState {
        return _items[idx];
    }
    public static function itemSetState(idx:Int, state:ItemState):Void {
        _items[idx] = state;
    }
    public static function itemStateToInt(state:ItemState):Int {
        return switch(state) {
        case ItemState.None: 0;
        case ItemState.Has:  1;
        case ItemState.Del:  2;
        }
    }
    public static function intToItemState(i:Int):ItemState {
        return switch(i) {
        case 0: ItemState.None;
        case 1: ItemState.Has;
        case 2: ItemState.Del;
        default: ItemState.None;
        }
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