package state;

import flixel.FlxState;
import flixel.FlxG;
import dat.DBLoader;

/**
 * 起動時に一度だけ呼び出される FlxState
 */
class BootState extends FlxState {
    override public function create():Void {
        super.create();

        // デフォルトカーソル非表示
        FlxG.mouse.useSystemCursor = true;

        // データベースファイル読み込み
        DBLoader.load();

#if debug
        FlxG.switchState(new PlayState());
#else
        FlxG.switchState(new TitleState());
#end
    }
}