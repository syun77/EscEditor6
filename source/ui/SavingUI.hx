package ui;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;

/**
 * セーブ中UI
 */
class SavingUI extends FlxSpriteGroup {
    static inline var TIME:Float = 2;
    
    var _time:Float = TIME;
    var _cnt:Int = 0;
    var _txt:FlxText;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        _txt = new FlxText(0, Const.getBottom(), 0, "Saving...", 16);
        _txt.x = FlxG.width - _txt.width;
        _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        _txt.y -= _txt.height;
        this.add(_txt);
    }

    /**
     * 更新
     * @param elapsed 
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _cnt++;
        switch(Std.int((_cnt%28)/7)) {
            case 0:
                _txt.text = "Saving";
            case 1:
                _txt.text = "Saving.";
            case 2:
                _txt.text = "Saving..";
            case 3:
                _txt.text = "Saving...";
        }
        _time -= elapsed;
        if(_time < 0) {
            exists = false;
        }
    }
}