package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import esc.EscFlagEditor;
import esc.EscGlobal;

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

        if(FlxG.keys.justPressed.V) {
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

        if(_flagEditor.isEnd()) {
            close();
        }
    }
}