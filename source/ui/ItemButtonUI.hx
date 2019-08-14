package ui;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import esc.EscGlobal;

/**
 * アイテムボタン
 */
class ItemButtonUI extends FlxSpriteGroup {

    static inline var MARGIN:Float = 8; // 余白

    var _bg:FlxSprite;
    var _item:FlxSprite;
    var _txt:FlxText;
    var _itemID:Int = EscGlobal.ITEM_INVALID;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        _bg = new FlxSprite(0, 0, Resources.BTN_ITEM_PATH);
        this.add(_bg);

        _item = new FlxSprite(0, 0);
        this.add(_item);

        _txt = new FlxText(0, _bg.height, _bg.width, "ITEM", 10);
        _txt.y -= _txt.height;
        _txt.alignment = FlxTextAlign.CENTER;
        _txt.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK, 1);
        this.add(_txt);

        x = FlxG.width - _bg.width - MARGIN;  
        y = MARGIN;
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        var itemID = EscGlobal.valGet(EscGlobal.VAL_ITEM);
        if(itemID == EscGlobal.ITEM_INVALID) {
            visible = false; // 表示不要
        }
        else {
            visible = true;
            if(_itemID != itemID) {
                // アイテムが変わった
                _item.loadGraphic(Resources.getItemPath(itemID));
                _itemID = itemID;
            }
        }
    }
}