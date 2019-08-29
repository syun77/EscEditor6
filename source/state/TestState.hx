package state;

import flixel.FlxG;
import flixel.FlxState;
import ui.DragPanelInputUI;

/**
 * テスト用画面
 */
class TestState extends FlxState {

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        this.add(new DragPanelInputUI("abcdef", 1234, 4));
    }
}
