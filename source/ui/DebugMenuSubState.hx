package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import esc.EscFlagEditor;

class DebugMenuSubState extends FlxSubState {
    var _flagEditor:EscFlagEditor = null;

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.5;
        this.add(bg);

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