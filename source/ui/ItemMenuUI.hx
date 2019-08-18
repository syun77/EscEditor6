package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import esc.EscGlobal;
import flixel.util.FlxDestroyUtil;
import ui.ItemButtonUI;
import ui.MenuUIBase;

class ItemMenuUI extends MenuUIBase {

    static inline var IMG_WIDTH:Int  = 92;
    static inline var IMG_HEIGHT:Int = 64;
    static inline var CNT_HORIZONTAL:Int = 4;
    static inline var CNT_VERTICAL:Int   = 4;

    var _bg:FlxSprite;
    var _bgLines:Array<FlxSprite>;
    var _sprItems:Array<FlxSprite>;
    var _ofsX:Float = 0;
    var _ofsY:Float = 0;
    var _itemList:Array<Int>;
    var _btnBack:FlxSprite;
    var _btnItem:ItemButtonUI;

    /**
     * コンストラクタ
     */
    public function new(itemButton:ItemButtonUI) {
        super();

        _btnItem = itemButton;

        _bg = new FlxSprite(0, FlxG.height/2).makeGraphic(FlxG.width, Std.int(IMG_HEIGHT * CNT_VERTICAL), FlxColor.BLACK);
        _bg.y -= _bg.height/2;
        _bg.alpha = 0.5;
        _bg.scale.y = 0;
        this.add(_bg);

        _bgLines = new Array<FlxSprite>();
        for(i in 0...2) {
            var py = _bg.y + (i * _bg.height);
            var spr = new FlxSprite(0, py).makeGraphic(FlxG.width, 2, FlxColor.WHITE);
            spr.y -= spr.height;
            _bgLines.push(spr);
            this.add(spr);
        }

        _btnBack = new FlxSprite(FlxG.width/2, _bg.y+_bg.height, Resources.BTN_BACK_PATH);
        _btnBack.x -= _btnBack.width/2;
        this.add(_btnBack);

        _itemList = new Array<Int>();
        _sprItems = new Array<FlxSprite>();

        // アイテム画像の描画オフセット値を計算
        _ofsX = (FlxG.width - (IMG_WIDTH * CNT_HORIZONTAL)) / 2;
        _ofsY = (FlxG.height - (IMG_HEIGHT * CNT_VERTICAL)) / 2;

        _close();
    }

    /**
     * 開く
     */
    public function open():Void {

        // 表示開始
        visible = true;
        exists = true;
        _bg.visible = true;
        _btnBack.visible = true;
        for(i in 0..._bgLines.length) {
            var spr = _bgLines[i];
            spr.visible = true;
            spr.x = spr.width * (1 - 2*i);
            FlxTween.tween(spr, {x:0}, 0.2, {ease:FlxEase.sineOut});
        }

        // 背景アニメーション開始
        _bg.scale.y = 0;
        FlxTween.tween(_bg.scale, {y:1}, 0.2, {ease:FlxEase.expoOut});

        for(i in 0...Const.MAX_ITEM) {
            if(EscGlobal.itemHas(i) == false) {
                continue;
            }
            var n = _itemList.length;
            // var path = "assets/images/item/" + Utils.fillZero(i, 3) + ".png";
            var path = Resources.getItemPath(i);
            var px:Float = (n % 4) * IMG_WIDTH;
            var py:Float = Std.int(n / 4) * IMG_HEIGHT;
            px += _ofsX;
            py += _ofsY;
            var spr = new FlxSprite(px+32, py, path);
            spr.alpha = 0;
            FlxTween.tween(spr, {x:px, alpha:1}, 1, {ease:FlxEase.expoOut, startDelay:i*0.02});
            _sprItems.push(spr);
            _itemList.push(i);
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

        if(FlxG.mouse.justPressed) {
            var i:Int = 0;
            for(idx in _itemList) {
                var spr = _sprItems[i];
                if(Utils.checkClickSprite(spr)) {
                    // アイテム装備
                    EscGlobal.itemEquip(idx);
                    return;
                }
                i++;
            }
        }

        // 閉じるチェック
        if(_checkToClose()) {
            _close();
        }
    }

    override public function isClosed():Bool {
        return exists == false;
    }

    /**
     * 閉じるチェック
     */
    function _checkToClose():Bool {
        if(FlxG.mouse.justPressed) {
            if(_btnItem.clicked()) {
                return true;
            }

            if(Utils.checkClickSprite(_btnBack)) {
                return true;
            }
        }

        if(FlxG.keys.justPressed.X) {
            return true;
        }
        if(FlxG.mouse.justPressedRight) {
            return true;
        }

        // 閉じる必要なし
        return false;
    }

    /**
     * 閉じる
     */
    function _close():Void {
        visible = false;
        exists = false;

        // アイテム画像を取り除く
        for(spr in _sprItems) {
            this.remove(spr, true);
            FlxDestroyUtil.destroy(spr);
        }

        _sprItems = new Array<FlxSprite>();
        _itemList = new Array<Int>();
    }
}