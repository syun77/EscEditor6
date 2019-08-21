package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import esc.debug.EscFlagEditor;
import esc.debug.EscVarEditor;
import esc.debug.EscItemEditor;
import esc.EscGlobal;

class DebugMenuSubState extends FlxSubState {
    static var _type:Int = 0;

    var _flagEditor:EscFlagEditor = null;
    var _varEditor:EscVarEditor = null;
    var _itemEditor:EscItemEditor = null;

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
        this.add(_varEditor);

        _itemEditor = new EscItemEditor();
        _itemEditor.x = 8;
        _itemEditor.y = 8;
        this.add(_itemEditor);

        _killAll();
        _type--;
        _change();
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(FlxG.keys.justPressed.F) {
        }

        if(FlxG.keys.justPressed.V) {
            _changeVarEdit();
        }
        if(FlxG.keys.justPressed.I) {
            _changeItemEdit();
        }
        if(FlxG.keys.justPressed.SPACE) {
            _change();
        }

        if(FlxG.keys.justPressed.X) {
            close();
        }
    }
    function _change():Void {
        _type = (_type + 1)%3;
        switch(_type) {
        case 0:
            _changeFlagEdit();
        case 1:
            _changeVarEdit();
        case 2:
            _changeItemEdit();
        }
    }

    function _changeFlagEdit():Void {
        _killAll();
        _flagEditor.exists = true;
    }
    function _changeVarEdit():Void {
        _killAll();
        _varEditor.exists = true;
        /*
        var str:String = "";
        for(i in 0...EscGlobal.MAX_VAL) {
            var v = EscGlobal.valGet(i);
            str += '${v},';
            if(i%10 == 9) {
                trace(str);
                str = "";
            }
        }
        */
    }
    function _changeItemEdit():Void {
        _killAll();
        _itemEditor.exists = true;
        /*
        for(i in 0...EscGlobal.MAX_ITEM) {
            trace('${i}:${EscGlobal.itemGetState(i)}');
        }
        */
    }

    function _killAll():Void {
        _flagEditor.exists = false;
        _varEditor.exists = false;
        _itemEditor.exists = false;
    }
}