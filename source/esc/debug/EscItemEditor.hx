package esc.debug;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import esc.EscGlobal;
import dat.ItemDB;

class EscItemEditor extends FlxSpriteGroup {
    // 最大表示数
    static inline var MAX_ITEM:Int = 12;
    static inline var FONT_SIZE:Int = 12;
    static inline var HEIGHT:Int = 14;
    static inline var OFS_Y:Int = 10;
    static inline var MARGIN_CURSOR_Y:Int = 8;
    static inline var CNT_REPEAT_INIT:Int = 10;
    static inline var CNT_REPEAT_MAIN:Int = 2;

    static var _cursor:Int = 1;

    var _top:Int    = 0; // 先頭項目番号
    var _cntRepeat:Int = 0;

    var _cursorSpr:FlxSprite;
    var _txts:Array<FlxText>;
    
    /**
     * 生成
     */
    public function new():Void {
        super();

        _cursorSpr = new FlxSprite(0, 0).makeGraphic(120, HEIGHT, FlxColor.GREEN);
        this.add(_cursorSpr);

        _txts = new Array<FlxText>();
        var py = 0;
        for(i in 0...MAX_ITEM) {
            var txt = new FlxText(0, py, 0, "", FONT_SIZE);
            txt.setFormat(Resources.FONT_PATH, FONT_SIZE);
            _txts.push(txt);
            py += HEIGHT;
        }

        for(txt in _txts) {
            this.add(txt);
        }
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        var v:Int = 1;
        if(FlxG.keys.pressed.Z) {
            v *= 10;
        }
        if(FlxG.keys.justPressed.UP) {
            _cursor -= v;
            _cntRepeat = CNT_REPEAT_INIT;
        }
        else if(FlxG.keys.pressed.UP) {
            _cntRepeat--;
            if(_cntRepeat <= 0) {
                _cursor -= v;
                _cntRepeat = CNT_REPEAT_MAIN;
            }
        }

        if(FlxG.keys.justPressed.DOWN) {
            _cursor += v;
            _cntRepeat = CNT_REPEAT_INIT;
        }
        else if(FlxG.keys.pressed.DOWN) {
            _cntRepeat--;
            if(_cntRepeat <= 0) {
                _cursor += v;
                _cntRepeat = CNT_REPEAT_MAIN;
            }
        }

        if(FlxG.keys.justPressed.LEFT) {
            // 左でアイテム削除
            EscGlobal.itemDel(_cursor);
        }
        if(FlxG.keys.justPressed.RIGHT) {
            // 右でアイテム追加
            EscGlobal.itemAdd(_cursor);
        }

        // 最小値・最大値チェック
        if(_cursor < 1) {
            _cursor = EscGlobal.MAX_ITEM - 1;
        }
        if(_cursor >= EscGlobal.MAX_ITEM) {
            _cursor = 1;
        }

        // 一番上の位置更新
        _updateTop();

        // テキスト更新
        _updateText();

        // カーソル更新
        _cursorSpr.y = (_cursor - _top) * HEIGHT + MARGIN_CURSOR_Y;
    }

    /**
     * 一番上の位置更新
     */
    function _updateTop():Void {
        if(_cursor < Std.int(MAX_ITEM/2)) {
            _top = 0;
        }
        else if(_cursor > EscGlobal.MAX_ITEM- MAX_ITEM) {
            _top = EscGlobal.MAX_ITEM - MAX_ITEM;
        }
        else {
            _top = _cursor - Std.int(MAX_ITEM/2);
        }
    }

    function _updateText():Void {
        for(i in 0..._txts.length) {
            var idx = i + _top;
            var txt = _txts[i];
            var state = EscGlobal.itemGetState(idx);
            var name = ItemDB.name(idx);
            if(name == "") {
                txt.text = '[${idx}] ${state}';
            }
            else {
                txt.text = '[${idx}] ${state} (${name})';
            }
            txt.color = FlxColor.WHITE;
            if(idx == 0) {
                txt.color = FlxColor.GRAY;
            }
        }
    }
}