package;

class EscGlobal {
    public static var flags:Array<Bool>;

    /**
     * 初期化
     */
    public static function init():Void {
        flags = new Array<Bool>();
        for(i in 0...128) {
            flags.push(false);
        }
    }

    /**
     * フラグ
     */
    public static function flagCheck(idx:Int):Bool {
        return flags[idx];
    }
    public static function flagSet(idx:Int, b:Bool):Void {
        flags[idx] = b;
    }
}