package state;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import esc.EscGlobal;

/**
 * 結果画面
 */
class ResultState extends FlxState {
    override public function create():Void {
        super.create();

        {
            var txt = new FlxText(0, 64, FlxG.width, "RESULT", 60);
            txt.alignment = FlxTextAlign.CENTER;
            this.add(txt);
        }

        var total:Int = EscGlobal.getScore();
        {
            var sec    = EscGlobal.getTimeLimit();
            var minute = Std.int(sec / 60);
            var second = Std.int(sec) % 60;

            var score = Std.int(sec) * 50; // タイムボーナス x50
            total += score;
            var time = 'TIME ${minute}:${Utils.fillZero(second, 2)} (+${score})';
            var txt = new FlxText(0, 200, FlxG.width, time, 24);
            txt.alignment = FlxTextAlign.CENTER;
            this.add(txt);
        }

        {
            var txt = new FlxText(0, 256, FlxG.width, 'FINAL SCORE', 32);
            txt.alignment = FlxTextAlign.CENTER;
            var txt2 = new FlxText(0, 300, FlxG.width, '${total}', 32);
            txt2.alignment = FlxTextAlign.CENTER;
            this.add(txt);
            this.add(txt2);
        }

        var btn = new FlxButton(FlxG.width/2, FlxG.height*2/3, "BACK TO TITLE", function() {
            FlxG.switchState(new TitleState());
        });
        Utils.scaleButton(btn, 3);
        // センタリング
        btn.x -= btn.width/2;
        btn.y -= btn.height/2;
        this.add(btn);
    }
}