package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import esc.EscGlobal;
import ui.ItemButtonUI;

class ItemMenuSubState extends FlxSubState {

    static inline var IMG_WIDTH:Int  = 92;
    static inline var IMG_HEIGHT:Int = 64;
    static inline var CNT_HORIZONTAL:Int = 4;
    static inline var CNT_VERTICAL:Int   = 4;

    var _sprItems:Array<FlxSprite>;
    var _ofsX:Float = 0;
    var _ofsY:Float = 0;
    var _itemList:Array<Int>;
    var _btnBack:FlxSprite;
    var _btnItem:ItemButtonUI;

    /**
     * コンストラクタ
     */
    public function new(btnItem:ItemButtonUI) {
        super();

        _btnItem = btnItem;

        var bg = new FlxSprite(0, FlxG.height/2).makeGraphic(FlxG.width, Std.int(IMG_HEIGHT * CNT_VERTICAL), FlxColor.BLACK);
        bg.y -= bg.height/2;
        bg.alpha = 0.5;
        bg.scale.y = 0;
        FlxTween.tween(bg.scale, {y:1}, 0.2, {ease:FlxEase.expoOut});
        this.add(bg);
    }

    /**
     * 生成
     */
    override public function create():Void {
        super.create();

        // アイテム画像の描画オフセット値を計算
        _ofsX = (FlxG.width - (IMG_WIDTH * CNT_HORIZONTAL)) / 2;
        _ofsY = (FlxG.height - (IMG_HEIGHT * CNT_VERTICAL)) / 2;

        _itemList = new Array<Int>();
        _sprItems = new Array<FlxSprite>();
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

        _btnBack = new FlxSprite(FlxG.width/2, FlxG.height, Resources.BTN_BACK_PATH);
        _btnBack.x -= _btnBack.width/2;
        _btnBack.y -= _btnBack.height*2;
        this.add(_btnBack);
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // アイテムボタンは別途更新する
        _btnItem.update(elapsed);

        if(FlxG.keys.justPressed.X) {
            _close();
        }
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
            if(Utils.checkClickSprite(_btnBack)) {
                _close();
            }
        }
    }

    /**
     * 閉じる
     */
    function _close():Void {
        close();
    }
}