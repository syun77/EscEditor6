package ui;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import esc.EscGlobal;

/**
 * アイテムボタン
 */
class ItemButtonUI extends FlxSpriteGroup {

    static inline var MARGIN:Float = 8; // 余白

    var _cnt:Float = 0;
    var _cnt2:Float = 0;
    var _bg:FlxSprite;
    var _bg2:FlxSprite;
    var _item:FlxSprite;
    var _txt:FlxText;
    var _itemID:Int = EscGlobal.ITEM_INVALID;

    /**
     * コンストラクタ
     */
    public function new() {
        super();

        _bg = new FlxSprite(0, 0);
        _bg.loadGraphic(Resources.BTN_ITEM_PATH, true);
        _bg.animation.add("0", [0], 1);
        _bg.animation.play("0");
        _bg.scale.set(0, 0);
        this.add(_bg);

        _bg2 = new FlxSprite(0, 0);
        _bg2.loadGraphic(Resources.BTN_ITEM_PATH, true);
        _bg2.animation.add("0", [1], 1);
        _bg2.animation.play("0");
        _bg2.alpha = 0;
        _bg2.scale.set(0, 0);
        this.add(_bg2);

        _item = new FlxSprite(0, 0);
        _item.scale.set(0, 0);
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

        _cnt += elapsed;
        _bg2.alpha = 0.2 + (0.2 * Math.sin(_cnt*4));
        _cnt2 += elapsed;
        if(_cnt2 > 1) {
            _cnt2 = 1;
        }
        {
            var sc = FlxEase.elasticOut(_cnt2);
            _item.scale.set(sc, sc);
            _bg.scale.set(sc, sc);
            _bg2.scale.set(sc, sc);
        }

        // 装備アイテムを取得する
        var itemID = EscGlobal.itemEquipGetID();
        if(itemID == EscGlobal.ITEM_INVALID) {
            if(EscGlobal.itemAllNone()) {
                visible = false;
            }
            else {
                // アイテムだけ非表示にする
                visible = true;
                _item.visible = false;
            }
        }
        else {
            visible = true;
            if(_itemID != itemID) {
                // アイテムが変わった
                _item.loadGraphic(Resources.getItemPath(itemID));
                _item.visible = true;
                _startClickedAnim();
            }
        }
        _itemID = itemID;
    }

    /**
     * クリックしたかどうか
     */
    public function clicked():Bool {
        if(EscGlobal.itemAllNone()) {
            return false;
        }

        if(Utils.checkClickSprite(_bg)) {
            // クリックした
            _startClickedAnim();
            return true;
        }

        return false;
    }

    function _startClickedAnim():Void {
        _cnt2 = 0;
    }
}