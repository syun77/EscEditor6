package ui;

import flixel.FlxG;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import esc.EscGlobal;

/**
 * スコア表示
 */
class ScoreUI extends FlxSpriteGroup {
    var _txtScore:FlxText;
    var _txtTime:FlxText;

    /**
     * コンストラクタ
     */
    public function new() {
        super();
        var py:Float = FlxG.height - 70;
        _txtScore = new FlxText(0, py, 0, "", 20);
        this.add(_txtScore);

        py += _txtScore.height;
        _txtTime = new FlxText(0, py, 0, "", 20);
        this.add(_txtTime);
    }

    /**
     * 更新
     * @param elapsed 経過時間
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // スコア更新
        _txtScore.text = 'SCORE: ${EscGlobal.getScore()}';

        // 制限時間更新
        EscGlobal.subTimeLimit(elapsed);
        var sec    = EscGlobal.getTimeLimit();
        var minute = Std.int(sec / 60);
        var second = Std.int(sec) % 60;

        var time = 'TIME LIMIT ${minute}:${Utils.fillZero(second, 2)}';
        _txtTime.text = time;

        if(sec < 1 * 60) {
            _txtTime.color = FlxColor.RED;
        }
    }
}