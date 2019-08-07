package ui;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

private class NumberInputUI extends FlxSpriteGroup {

    static inline var DEFAULT_COLOR:Int = FlxColor.GRAY;

    var _num:Int = 0;
    var _txt:FlxText;
    var _sprList:Array<FlxSprite>;
    var _upperY:Float = 0;
    var _bottomY:Float = 0;

    public function new(px:Float, py:Float, num:Int) {
        super();

        _num = num;

        _sprList = new Array<FlxSprite>();
        var size:Float = 20;
        for(i in 0...2) {
            var spr = new FlxSprite(0, 0, Resources.NUM_ARROW);
            var px2 = px;
            var py2 = py;
            var rot:Float = 0;
            size = spr.height;
            if(i == 0) {
                py2 = py - size;
                _upperY = py2;
            }
            else {
                py2 = py + size * 1.1;
                rot = 180;
                _bottomY = py2;
            }
            size = spr.height;
            spr.x = px2;
            spr.y = py2;
            spr.angle = rot;
            spr.color = DEFAULT_COLOR;
            _sprList.push(spr);
        }

        for(spr in _sprList) {
            this.add(spr);
        }

        _txt = new FlxText(px, py, Std.int(size), '${_num}', Std.int(size));
        _txt.alignment = FlxTextAlign.CENTER;
        this.add(_txt);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _txt.text = '${_num}';

        if(FlxG.mouse.justPressed) {
            for(i in 0..._sprList.length) {
                var spr = _sprList[i];
                var clicked = Utils.checkClickSprite(spr);
                if(clicked == false) {
                    continue;
                }

                var ynext:Float = 0;
                if(i == 0) {
                    _num++;
                    if(_num > 9) {
                        _num = 0;
                    }
                    ynext = _upperY;
                    spr.y = ynext - (spr.height * 0.1);
                }
                else {
                    _num--;
                    if(_num < 0) {
                        _num = 9;
                    }
                    ynext = _bottomY;
                    spr.y = ynext + (spr.height * 0.1);
                }
                FlxTween.color(spr, 0.1, FlxColor.WHITE, DEFAULT_COLOR);
                FlxTween.tween(spr, {y:ynext}, 0.1, {ease:FlxEase.expoOut});
            }
        }
    }
}

class NumberInputSubState extends FlxSubState {
    public function new() {
        super();

        var numUI = new NumberInputUI(200, 200, 5);
        this.add(numUI);
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(FlxG.keys.justPressed.X) {
            close();
        }
    }
}