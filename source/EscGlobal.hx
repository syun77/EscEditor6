package;

class EscGlobal {
    public static inline var MAX_FLAG:Int = 100; // フラグの最大数 (0無効)
    public static inline var SCENE_INVALID:Int = 0; // 無効なシーンID

    // フラグ
    static var _flags:Array<Bool>;

    // 次のシーン
    static var _nextScene:Int = SCENE_INVALID;

    /**
     * 初期化
     */
    public static function init():Void {
        _flags = new Array<Bool>();
        for(i in 0...MAX_FLAG) {
            _flags.push(false);
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
}