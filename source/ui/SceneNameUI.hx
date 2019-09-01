package ui;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;

/**
 * シーン名表示
 */
class SceneNameUI extends FlxSpriteGroup {

    /**
     * 生存時間
     */
    static inline var TIMER:Float = 3;

    var _cnt:Float = TIMER;
    var _t:Float = 0;
    var _txt:FlxText;

    /**
     * コンストラクタ
     * @param sceneID 
     */
    public function new(sceneID:Int) {
        super();

        // シーン名表示
        {
            _txt = new FlxText(8, -32, 0);
            _txt.setFormat(Resources.FONT_PATH, Resources.FONT_SIZE);
            _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
            _txt.text = dat.SceneDB.get(sceneID).name;
            this.add(_txt);
        }
    }

    /**
     * 更新
     * @param elapsed 
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        _cnt -= elapsed;
        if(_cnt > 0.5) {
            var ratio = Utils.lerpRatio(_cnt, 2, TIMER, FlxEase.expoIn);
            _txt.y = 8 - (32 * ratio);
        }
        else {
            var d = elapsed * 2;
            _txt.alpha = Math.max(_txt.alpha - d, 0);
        }

        if(_cnt <= 0) {
            exists = false;
        }
    }
}