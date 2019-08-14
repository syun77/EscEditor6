package ui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

class InformationUI extends FlxSpriteGroup {

    static inline var HEIGHT:Int = 40;

    var _bg:FlxSprite;
    var _txt:FlxText;
    var _tween:FlxTween = null;

    public function new() {
        super();

        // 背景
        {
            var h = HEIGHT;
            _bg = new FlxSprite(0, FlxG.height-h-5).makeGraphic(FlxG.width, h, FlxColor.WHITE);
            _bg.color = FlxColor.BLACK;
            _bg.alpha = 0.5;
            this.add(_bg);
        }

        // テキスト
        _txt = new FlxText(0, FlxG.height-40, FlxG.width, null);
        _txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
        _txt.alignment = FlxTextAlign.CENTER;
        this.add(_txt);

        visible = false;
        _bg.scale.y = 0;
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(_tween != null) {
            var t = _tween.scale * 5;
            if(t > 1) {
                t = 1;
            }
           _bg.scale.y = FlxEase.expoOut(t); 
        }
    }

    override public function destroy():Void {
        if(_tween != null) {
            _tween.cancel();
            _tween = null;
        }
    }

    public function start(msg:String, time:Float):Void {
        if(_tween != null) {
            _tween.cancel();
            _tween = null;
        }

        _txt.text = msg;
        visible = true;
        _tween = FlxTween.tween(_txt, {}, time, {onComplete:function(_) {
            visible = false;
            _bg.scale.y = 0;
            _tween = null;
        }});
    }
}