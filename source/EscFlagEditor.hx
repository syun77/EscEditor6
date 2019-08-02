package;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

/**
 * フラグ編集
 */
class EscFlagEditor extends FlxSpriteGroup {
    static inline var FONT_SIZE:Int = 20;
    static inline var WIDTH:Int = 20;
    static inline var HEIGHT:Int = 20;

    var _isEnd:Bool = false;
    var _txts:Array<FlxText>;
    var _sprHorizontal:FlxSprite;
    var _sprVertical:FlxSprite;
    var _txtHeaders:Array<FlxText>;
    var _cursor:Int = 0;
    var _txtCaption:FlxText;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        // 撰択カーソル
        _sprHorizontal = new FlxSprite().makeGraphic(WIDTH*11, HEIGHT, FlxColor.WHITE);
        _sprVertical = new FlxSprite().makeGraphic(WIDTH, HEIGHT*11, FlxColor.WHITE);
        this.add(_sprHorizontal);
        this.add(_sprVertical);

        // 文字
        _txts = new Array<FlxText>();
        for(j in 0...10) {
            for(i in 0...10) {
                var px = (i + 1) * WIDTH;
                var py = (j + 1) * HEIGHT;
                var txt = new FlxText(px, py, 0, "0", FONT_SIZE);
                _txts.push(txt);
            }
        }

        for(txt in _txts) {
            this.add(txt);
        }

        // ヘッダ文字
        _txtHeaders = new Array<FlxText>();
        for(i in 0...10) {
            var px = (i + 1) * WIDTH;
            var py = 0;
            var txt = new FlxText(px, py, 0, '${i}', FONT_SIZE);
            txt.color = FlxColor.GRAY;
            _txtHeaders.push(txt);
        }
        for(j in 0...10) {
            var px = 0;
            var py = (j + 1) * HEIGHT;
            var txt = new FlxText(px, py, 0, '${j}', FONT_SIZE);
            txt.color = FlxColor.GRAY;
            _txtHeaders.push(txt);
        }
        for(txt in _txtHeaders) {
            this.add(txt);
        }

        _txtCaption = new FlxText(8, HEIGHT*12, 0, 16);
        this.add(_txtCaption);
    }

    public function isEnd():Bool {
        return _isEnd;
    }

    /**
     * 更新
     */
    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        // カーソルを更新
        _updateCursor();

        if(FlxG.keys.justPressed.Z) {
            // フラグのOn/Off切り替え
            var flag = EscGlobal.flagCheck(_cursor);
            EscGlobal.flagSet(_cursor, flag == false);
        }

        var idx:Int = 0;
        for(txt in _txts) {
            if(EscGlobal.flagCheck(idx)) {
                txt.text = "1";
            }
            else {
                txt.text = "0";
            }
            idx++;
        }

        if(FlxG.keys.justPressed.X) {
            // 終了
            _isEnd = true;
        }
    }

    /**
     * カーソルの更新
     */
    function _updateCursor():Void {
        var digitX = _cursor%10;
        var digitY = Math.floor(_cursor/10)%10;
        {
            _sprVertical.x = (digitX + 1) * WIDTH + x - 2;
            _sprHorizontal.y = (digitY + 1) * HEIGHT + y + 2;
        }

        if(FlxG.keys.justPressed.LEFT) {
            digitX--;
            if(digitX < 0) {
                digitX = 9;
            }
        }
        if(FlxG.keys.justPressed.RIGHT) {
            digitX++;
            if(digitX > 9) {
                digitX = 0;
            }
        }
        if(FlxG.keys.justPressed.UP) {
            digitY--;
            if(digitY < 0) {
                digitY = 9;
            }
        }
        if(FlxG.keys.justPressed.DOWN) {
            digitY++;
            if(digitY > 9) {
                digitY = 0;
            }
        }

        _cursor = (digitY * 10) + digitX;

        var idx:Int = 0;
        for(txt in _txts) {
            if(idx == _cursor) {
                txt.color = FlxColor.LIME;
                if(EscGlobal.flagCheck(_cursor)) {
                    txt.color = FlxColor.RED;
                }
            }
            else {
                txt.color = FlxColor.WHITE;
            }
            idx++;
        }

        {
            var str = '${_cursor}: ';
            var color = FlxColor.BLUE;
            if(EscGlobal.flagCheck(_cursor)) {
                str += "On";
                _txtCaption.color = FlxColor.RED;
                color = FlxColor.PURPLE;
            }
            else {
                str += "Off";
                _txtCaption.color = FlxColor.LIME;
            }
            _txtCaption.text = str;
            _sprHorizontal.color = color;
            _sprVertical.color = color;
        }
    }

    /**
     * 描画
     */
    public override function draw():Void {
        super.draw();
    }
}