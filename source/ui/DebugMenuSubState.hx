package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import esc.debug.EscFlagEditor;
import esc.debug.EscVarEditor;
import esc.EscGlobal;

class DebugMenuSubState extends FlxSubState {
    var _flagEditor:EscFlagEditor = null;
    var _varEditor:EscVarEditor = null;

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        _flagEditor = new EscFlagEditor();
		_flagEditor.x = 8;
		_flagEditor.y = 8;
        this.add(_flagEditor);

        _varEditor = new EscVarEditor();
        _varEditor.x = 8;
        _varEditor.y = 8;
        _varEditor.exists = false; // 非表示
        this.add(_varEditor);
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(FlxG.keys.justPressed.F) {
            _killAll();
            _flagEditor.exists = true;
        }

        if(FlxG.keys.justPressed.V) {
            _killAll();
            _varEditor.exists = true;
            var str:String = "";
            for(i in 0...EscGlobal.MAX_VAL) {
                var v = EscGlobal.valGet(i);
                str += '${v},';
                if(i%10 == 9) {
                    trace(str);
                    str = "";
                }
            }
        }
        if(FlxG.keys.justPressed.I) {
            for(i in 0...EscGlobal.MAX_ITEM) {
                trace('${i}:${EscGlobal.itemHas(i)}');
            }
        }

        if(FlxG.keys.justPressed.X) {
            close();
        }
    }

    function _killAll():Void {
        _flagEditor.exists = false;
        _varEditor.exists = false;
    }
}