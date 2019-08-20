package;

import flixel.FlxG;

class Const {
    public static inline var MAX_ITEM:Int = 12;
    public static inline var MARGIN_HEIGHT:Int = 160; // 画面下が 160px 余白がある状態にする

    public static function getBottom():Float {
        return FlxG.height - MARGIN_HEIGHT;
    }
}