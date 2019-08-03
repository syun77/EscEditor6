package esc;

import flixel.FlxSprite;

class EscSprite extends FlxSprite {
    public var obj:EscLoader.EscObj = null;
    public override function update(elapsed:Float) {
        super.update(elapsed);
        // 座標を反映
        obj.x = x;
        obj.y = y;
    }
}
