package ui;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import esc.EscGlobal;
import esc.EscVar;
import flixel.util.FlxDestroyUtil;
import ui.ItemButtonUI;
import ui.MenuUIBase;
import ui.DraggableUI;
import state.PlayState;

/**
 * 状態
 */
private enum State {
    Standby;
    Dragging;
    MsgWait;
}

class ItemMenuUI extends MenuUIBase {

    static inline var IMG_WIDTH:Int  = 92;
    static inline var IMG_HEIGHT:Int = 64;
    static inline var CNT_HORIZONTAL:Int = 4;
    static inline var CNT_VERTICAL:Int   = 4;

    /**
     * 状態
     */
    var _state:State = State.Standby;
    var _cnt:Float = 0;

    var _bg:FlxSprite;
    var _bgLines:Array<FlxSprite>;
    var _itemBg:FlxSprite;
    var _itemBg2:FlxSprite;
    var _sprItems:Array<DraggableUI>;
    var _ofsX:Float = 0;
    var _ofsY:Float = 0;
    var _btnBack:FlxSprite;
    var _btnItem:ItemButtonUI;
    var _draggedSpr:DraggableUI = null;

    /**
     * コンストラクタ
     */
    public function new(itemButton:ItemButtonUI) {
        super();

        _btnItem = itemButton;

        _bg = new FlxSprite(0, FlxG.height/2).makeGraphic(FlxG.width, Std.int(IMG_HEIGHT * CNT_VERTICAL), FlxColor.BLACK);
        _bg.y -= _bg.height/2;
        _bg.alpha = 0.3;
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

        _sprItems = new Array<DraggableUI>();

        // アイテム画像の描画オフセット値を計算
        _ofsX = (FlxG.width - (IMG_WIDTH * CNT_HORIZONTAL)) / 2;
        _ofsY = (FlxG.height - (IMG_HEIGHT * CNT_VERTICAL)) / 2;

        // 選択アイテム背景
        _itemBg = new FlxSprite(0, 0);
        _itemBg.loadGraphic(Resources.BTN_ITEM_PATH, true);
        _itemBg.animation.add("0", [2], 1);
        _itemBg.animation.play("0");
        _itemBg.exists = false;
        this.add(_itemBg);

        _itemBg2 = new FlxSprite(0, 0);
        _itemBg2.loadGraphic(Resources.BTN_ITEM_PATH, true);
        _itemBg2.animation.add("0", [2], 1);
        _itemBg2.animation.play("0");
        _itemBg2.exists = false;
        this.add(_itemBg2);

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

        for(i in 0...EscGlobal.MAX_ITEM) {
            if(EscGlobal.itemHas(i) == false) {
                continue;
            }
            var n = _sprItems.length;
            var path = Resources.getItemPath(i);
            var px:Float = (n % 4) * IMG_WIDTH;
            var py:Float = Std.int(n / 4) * IMG_HEIGHT;
            px += _ofsX;
            py += _ofsY;
            var spr = new DraggableUI(px+32, py, path);
            spr.setStart(px, py);
            spr.setParam(i);
            spr.alpha = 0;
            FlxTween.tween(spr, {x:px, alpha:1}, 1, {ease:FlxEase.expoOut, startDelay:i*0.02});
            _sprItems.push(spr);
        }

        for(spr in _sprItems) {
            this.add(spr);
        }

        _state = State.Standby;
        FlxG.watch.add(this, "_state");
    }

    /**
     * 更新
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        _cnt += elapsed;

        switch(_state) {
            case State.Standby:
                _updateStandby();
            case State.Dragging:
                _updateDragging();
            case State.MsgWait:
                // スクリプト終了待ち
                _draggedSpr.endWait();
                // アイテムリストを作り直す
                _refreshItems();
                _state = State.Standby;
        }

        // 閉じるチェック
        if(_checkToClose()) {
            _close();
        }
    }

    /**
     * 更新・待機
     */
    function _updateStandby():Void {
        for(spr in _sprItems) {
            if(spr.isDragged()) {
                // 最前面に移動
                this.remove(spr, true);
                this.add(spr);
                _draggedSpr = spr;
                // アイテム装備
                var itemID = _draggedSpr.param;
                EscGlobal.itemEquip(itemID);
                _state = State.Dragging;
            }
        }
    }

    /**
     * 更新・ドラッグ中
     */
    function _updateDragging():Void {
        // 背景表示
        _itemBg.x = _draggedSpr.x;
        _itemBg.y = _draggedSpr.y;
        _itemBg.visible = true;
        var rate = Math.abs(0.5 * Math.sin(_cnt * 16));
        _itemBg.color = FlxColor.interpolate(FlxColor.RED, FlxColor.WHITE, rate);
        var sc = 1 + 0.2 * rate;
        _itemBg.scale.set(sc, sc);
        _draggedSpr.scale.set(sc, sc);

        // 他のアイテムとの接触判定
        _itemBg2.visible = false;
        _itemBg2.scale.set(sc, sc);
        _itemBg2.color = FlxColor.interpolate(FlxColor.YELLOW, FlxColor.WHITE, rate*2);
        var hitSpr:DraggableUI = null;
        var distance:Float = 1000000000;
        for(spr in _sprItems) {
            FlxG.overlap(_draggedSpr, spr, function(a:DraggableUI, b:DraggableUI) {
                if(a == b) {
                    // 自分自身
                    return;
                }
                var d = FlxMath.distanceBetween(a, b);
                if(d > distance) {
                    return; // 遠いので判定不要
                }
                distance = d;
                hitSpr = spr;

                _itemBg2.visible = true;
                _itemBg2.x = b.x;
                _itemBg2.y = b.y;
            });
        }

        if(_draggedSpr.isJustReleased()) {
            // 離した
            _draggedSpr.scale.set(1, 1);
            // 合成・調べる判定
            _itemBg.visible = false;
            _itemBg2.visible = false;
            // 変数経由でパラメータを渡す
            var itemID1 = _draggedSpr.param;
            var itemID2 = EscGlobal.ITEM_INVALID;
            if(hitSpr != null) {
                itemID2 = hitSpr.param;
                if(itemID2 < itemID1) {
                    // 数値の小さい方を先にする
                    itemID2 = itemID1;
                    itemID1 = hitSpr.param;
                    trace(itemID1, itemID2);
                }
                else {
                    trace(itemID1, itemID2);
                }
            }
            EscGlobal.valSet(EscVar.CRAFT1, itemID1); // 合成アイテム１
            EscGlobal.valSet(EscVar.CRAFT2, itemID2); // 合成アイテム２
            if(hitSpr != null || _draggedSpr.isMovingDistanceHalf()) {
                // メッセージ表示
                var itemID = _draggedSpr.param;
                PlayState.getEditor().startScript(Resources.ADV_ITEM_PATH);
                _state = State.MsgWait;
            }
            else {
                // 戻り処理
                _draggedSpr.endWait();
                _state = State.Standby;
            }
        }
    }

    function _refreshItems():Void {
        var idx = 0;
        for(i in 0...EscGlobal.MAX_ITEM) {
            if(EscGlobal.itemHas(i) == false) {
                for(spr in _sprItems) {
                    if(i != spr.param) {
                        continue;
                    }
                    if(EscGlobal.itemHas(spr.param) == false) {
                        // 削除されたアイテムを取り除く
                        this.remove(spr, true);
                        FlxDestroyUtil.destroy(spr);
                        _sprItems.remove(spr);
                        break;
                    }
                }
                continue;
            }

            var n = idx;
            var path = Resources.getItemPath(i);
            var px:Float = (n % 4) * IMG_WIDTH;
            var py:Float = Std.int(n / 4) * IMG_HEIGHT;
            px += _ofsX;
            py += _ofsY;
            var spr:DraggableUI = null;
            _sprItems.map(function(spr2) {
                if(i == spr2.param) {
                    spr = spr2;
                }
            });
            if(spr == null) {
                // 存在しないので新規作成
                spr = new DraggableUI(_btnItem.x, _btnItem.y, path);
                spr.setParam(i);
                _sprItems.push(spr);
                this.add(spr);
            }
            spr.setStart(px, py);

            idx++;
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
        _sprItems = new Array<DraggableUI>();
        _draggedSpr = null;
        _itemBg.visible = false;
        _itemBg2.visible = false;
    }
}