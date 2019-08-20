package ui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

class InformationUI extends FlxSpriteGroup {

    static inline var TIMER:Float = 3;

    var _txt:FlxText;
    var _cnt:Float = 0;

    public function new() {
        super();

        // テキスト
        _txt = new FlxText(0, Const.getBottom(), FlxG.width, null);
        _txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
        _txt.alignment = FlxTextAlign.CENTER;
        _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
        this.add(_txt);

        visible = false;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(_cnt > 0) {
            _cnt -= elapsed;
        }
        else {
            if(_txt.alpha > 0) {
                _txt.alpha -= elapsed * 2;
                if(_txt.alpha < 0) {
                    _txt.alpha = 0;
                    visible = false;
                }
            }
        }
    }

    public function start(msg:String, time:Float):Void {
        _cnt = time;
        _txt.text = msg;
        visible = true;
        _txt.alpha = 1;
    }
}