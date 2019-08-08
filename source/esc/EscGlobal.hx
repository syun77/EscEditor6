package esc;

class EscGlobal {
    public static inline var MAX_FLAG:Int = 100; // フラグの最大数 (0無効)
    public static inline var MAX_VAL:Int  = 100; // 変数の最大数
    public static inline var SCENE_INVALID:Int = 0; // 無効なシーンID

    // フラグ
    static var _flags:Array<Bool>;
    // 変数
    static var _vals:Array<Int>;

    // 次のシーン
    static var _nextScene:Int = SCENE_INVALID;

    // 数値入力情報
    static var _numberInputIdx:Int = 0; // 受け渡しする変数番号
    static var _numberInputDigit:Int = 0; // 受渡しする桁数

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
}