package state;

import flixel.FlxState;
import flixel.FlxG;
import dat.Layout;
import dat.SceneDB;

/**
 * 起動時に一度だけ呼び出される FlxState
 */
class BootState extends FlxState {
    override public function create():Void {
        super.create();

        // CDBファイル読み込み
        var content = openfl.Assets.getText("source/dat/layout.cdb");
        // ロード実行
        Layout.load(content);

#if debug
        FlxG.switchState(new PlayState());
#else
        FlxG.switchState(new TitleState());
#end
    }
}