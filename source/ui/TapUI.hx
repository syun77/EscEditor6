package ui;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

/**
 * タップ演出UI
 */
class TapUI extends FlxSprite {
    static inline var TIMER:Float = 1.0; // 生存時間 (秒)
    static inline var SCALE:Float = 1.0; // 最大数スケール値

    var _tween:FlxTween = null;

    /**
     * コンストラクタ
     */
    public function new() {
        super(0, 0, Resources.TAP_PATH);
        visible = false;
    }

    /**
     * 演出開始
     */
    public function start(px:Float, py:Float):Void {
        x = px - width/2;
        y = py - height/2;
        if(_tween != null) {
            _tween.cancel();
            _tween = null;
        }
        scale.set(0, 0);
        visible = true;

        _tween = FlxTween.tween(this.scale, {x:SCALE, y:SCALE}, TIMER, {ease:FlxEase.expoOut, onComplete:function(tw:FlxTween) {
            _tween = null;
            visible = false;
        }});
        alpha = 1;
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(alpha > 0) {
            alpha -= elapsed;
        }
    }
}