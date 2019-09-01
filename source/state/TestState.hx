package state;

import flixel.FlxG;
import flixel.FlxState;
import ui.DragPanelInputUI;
import ui.KanaInputUI;

/**
 * テスト用画面
 */
class TestState extends FlxState {

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        // this.add(new DragPanelInputUI(1));
        this.add(new KanaInputUI(1));
    }
}
