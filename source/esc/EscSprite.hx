package esc;

import flixel.FlxSprite;
import esc.EscObj;

class EscSprite extends FlxSprite {
    var _obj:EscObj = null;

    public function new(px:Float, py:Float, obj:EscObj) {
        trace("load: " + obj.getImage());
        super(px, py, obj.getImage());
        _obj = obj;
    }

    public function getObj():EscObj {
        return _obj;
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
        // 座標を反映
        _obj.x = x;
        _obj.y = y;
    }
}
