package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class ItemMenuSubState extends FlxSubState {

    static inline var IMG_WIDTH:Int  = 128;
    static inline var IMG_HEIGHT:Int = 128;
    static inline var CNT_HORIZONTAL:Int = 4;
    static inline var CNT_VERTICAL:Int   = 3;

    var _sprItems:Array<FlxSprite>;
    var _ofsX:Float = 0;
    var _ofsY:Float = 0;

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        // アイテム画像の描画オフセット値を計算
        _ofsX = (FlxG.width - (IMG_WIDTH * CNT_HORIZONTAL)) / 2;
        _ofsY = (FlxG.height - (IMG_HEIGHT * CNT_VERTICAL)) / 2;

        _sprItems = new Array<FlxSprite>();
        for(i in 0...Const.MAX_ITEM) {
            var path = "assets/images/item/" + Utils.fillZero(i, 3) + ".png";
            var px:Float = (i % 4) * IMG_WIDTH;
            var py:Float = Math.floor(i / 4) * IMG_HEIGHT;
            px += _ofsX;
            py += _ofsY;
            var spr = new FlxSprite(px+32, py, path);
            spr.alpha = 0;
            FlxTween.tween(spr, {x:px, alpha:1}, 1, {ease:FlxEase.expoOut, startDelay:i*0.02});
            _sprItems.push(spr);
        }

        for(spr in _sprItems) {
            this.add(spr);
        }
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        if(FlxG.keys.justPressed.X) {
            _close();
        }
    }

    /**
     * 閉じる
     */
    function _close():Void {
        close();
    }
}