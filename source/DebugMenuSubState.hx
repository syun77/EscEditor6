package;

import flixel.FlxSubState;

class DebugMenuSubState extends FlxSubState {
    var _flagEditor:EscFlagEditor = null;

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        _flagEditor = new EscFlagEditor();
		_flagEditor.x = 300;
		_flagEditor.y = 32;
        this.add(_flagEditor);
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(_flagEditor.isEnd()) {
            close();
        }
    }
}