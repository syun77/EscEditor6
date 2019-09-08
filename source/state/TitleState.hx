package state;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

/**
 * タイトル画面
 */
class TitleState extends FlxState {

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        var txt = new FlxText(0, FlxG.height/4, FlxG.width, "Escape Game", 48);
        txt.alignment = FlxTextAlign.CENTER;
        txt.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLUE);
        this.add(txt);
        var txt2 = new FlxText(FlxG.width*3/4, txt.y+txt.height, 0, "v 4.00");
        this.add(txt2);

        var btn = new FlxButton(FlxG.width/2, FlxG.height*2/3, "START", function() {
            FlxG.switchState(new PlayState());
        });
        Utils.scaleButton(btn, 3);
        // センタリング
        btn.x -= btn.width/2;
        btn.y -= btn.height/2;
        this.add(btn);
    }
}