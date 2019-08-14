package ui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class InformationUI extends FlxSpriteGroup {

    var _txt:FlxText;
    var _tween:FlxTween = null;

    public function new() {
        super();

        _txt = new FlxText(0, FlxG.height-40, FlxG.width, null);
        _txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
        _txt.alignment = FlxTextAlign.CENTER;
        this.add(_txt);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
    }

    public function start(msg:String, time:Float):Void {
        if(_tween != null) {
            _tween.cancel();
            _tween = null;
        }

        _txt.text = msg;
        _txt.visible = true;
        _tween = FlxTween.tween(_txt, {}, time, {onComplete:function(_) {
            _txt.visible = false;
            _tween = null;
        }});
    }
}