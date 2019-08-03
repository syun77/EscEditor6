package esc;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import hscript.Parser;
import hscript.Interp;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class EscSprite extends FlxSprite {
    public var obj:EscLoader.EscObj = null;
    public override function update(elapsed:Float) {
        super.update(elapsed);
        // 座標を反映
        obj.x = x;
        obj.y = y;
    }
}

class EscEditor extends FlxSpriteGroup {
    var _isEdit:Bool = false;
    var _loader:EscLoader;
    var _bg:EscSprite;
    var _objs:Array<EscSprite>;
    var _selobj:EscSprite = null;
    var _selframe:FlxSprite = null;
    var _txts:Array<FlxText>;
    var _txtNotice:FlxText;
    var _tweenNotice:FlxTween = null;

    /**
     * コンストラクタ
     */
    public function new(root:String, isEdit:Bool) {
        super();

        _isEdit = isEdit;
        _loader = new EscLoader(root);
        _txts = new Array<FlxText>();

        // 背景の読み込み
        {
            var bg = _loader.bg;
            var file = _loader.bg.getImage();
            _bg = new EscSprite(bg.x, bg.y, file);
            bg.setText(_addText());
            _bg.obj = bg;
            this.add(_bg);
        }

        // 選択枠
        _selframe = new FlxSprite(0, 0);
        _selframe.visible = false;
        this.add(_selframe);

        // 配置オブジェクト
        _objs = new Array<EscSprite>();
        for(obj in _loader.objs) {
            var file = obj.getImage();
            var spr = new EscSprite(obj.x, obj.y, file);
            obj.setText(_addText());
            spr.obj = obj;
            _objs.push(spr);
        }

        for(obj in _objs) {
            this.add(obj);
        }

        // ヘルプテキスト
        for(txt in _txts) {
            if(isEdit == false) {
                txt.visible = false;
            }
            this.add(txt);
        }

        // 通知テキスト
        _txtNotice = new FlxText(0, FlxG.height-40, FlxG.width, null);
        _txtNotice.setFormat("assets/fonts/PixelMplus12-Regular.ttf", 20);
        _txtNotice.alignment = FlxTextAlign.CENTER;
        this.add(_txtNotice);

        // 表示オブジェクト更新
        _updateObjVisible();
    }

    /**
     * 編集フラグを設定する
     */
    public function setEdit(b:Bool):Void {
        _isEdit = b;
        for(txt in _txts) {
            txt.visible = b;
        }
    }
    public function isEdit():Bool {
        return _isEdit;
    }

    /**
     * テキストの追加
     */
    function _addText():FlxText {
        var length:Int = _txts.length;
        var x:Float = 8;
        var y:Float = 8 + (length * 24);
        var txt = new FlxText(x, y);
        var size:Int = 20;
        txt.setFormat(null, size);
        _txts.push(txt);
        return txt;
    }

	/**
	 * クリックしたオブジェクトを取得
	 */
    function _clickObj():EscSprite {
		for(obj in _objs) {
            if(obj.visible == false) {
                // 非表示時はクリックできない
                continue;
            }
			var x:Float = FlxG.mouse.x;
			var y:Float = FlxG.mouse.y;
			var x1:Float = obj.x;
			var y1:Float = obj.y;
			var x2:Float = obj.x + obj.width;
			var y2:Float = obj.y + obj.height;
			if(x1 < x && x < x2) {
				if(y1 < y && y < y2) {
                    // 画像領域内にマウスカーソルが存在する
					return obj;
				}
			}
		}

		return null;
    }

    function _startNotice(msg:String, time:Float):Void {
        if(_tweenNotice != null) {
            _tweenNotice.cancel();
            _tweenNotice = null;
        }
        _txtNotice.text = msg;
        _tweenNotice = FlxTween.tween(_txtNotice, {}, time, {onComplete:function(_) {
            _txtNotice.text = "";
            _tweenNotice = null;
        }});
    }

    /**
     * オブジェクトをクリックした時の処理
     */
    function _onClick(obj:EscLoader.EscObj):Void {
        trace('click: ${_loader.getRoot()}${obj.click}.txt');
        var str = obj.getClick();
        if(str == null) {
            return;
        }
        trace(str);
        var parser = new Parser();
        var program = parser.parseString(str);
        var interp = new Interp();
        // 関数登録
        interp.variables.set("BITON", function(idx:Int) { EscGlobal.flagSet(idx, true); } );
        interp.variables.set("BITOFF", function(idx:Int) { EscGlobal.flagSet(idx, false); } );
        interp.variables.set("NOTICE", function(msg:String) { _startNotice(msg, 3); } );
        interp.variables.set("BITCHK", function(idx:Int) { return EscGlobal.flagCheck(idx); } );
        interp.variables.set("JUMP", function(idx:Int) { EscGlobal.setNextSceneID(idx); } );
        var func = interp.execute(program);
        func();
    }

    /**
     * 更新
     */
    public override function update(elapsed:Float):Void {
        super.update(elapsed);

		// クリックしたオブジェクトを取得する
		if(FlxG.mouse.justPressed) {
			_selobj = _clickObj();
			if(_selobj != null) {
				var width:Float = _selobj.width + 4;
				var height:Float = _selobj.height + 4;
				_selframe.makeGraphic(Std.int(width), Std.int(height), FlxColor.RED);
                _onClick(_selobj.obj);
			}
		}

        if(isEdit()) {
            // デバッグ用更新
            _updateDebug();
        }
        else {
            _updateObjVisible();
        }
    }

    function _updateObjVisible():Void {
        for(spr in _objs) {
            var on = spr.obj.flagOn;
            var off = spr.obj.flagOff;
            spr.visible = false;
            if(on == 0 || EscGlobal.flagCheck(on)) {
                // 表示フラグが有効
                spr.visible = true;
                if(off > 0 && EscGlobal.flagCheck(off)) {
                    // 非表示フラグが有効
                    spr.visible = false;
                }
            }
        }
    }

    /**
     * デバッグ表示の更新
     */
    function _updateDebug():Void {

        for(spr in _objs) {
            spr.visible = true;
        }

        if(FlxG.keys.justPressed.Z) {
            // テキストに出力する
            trace("\n" + _loader.build());
        }
        
		var str:String = "";
		_txts[0].text = _loader.bg.getString();
		for(i in 0...2) {
			str = "";
			var obj = _loader.objs[i];
			_txts[i + 1].text = obj.getString();
		}

		_selframe.visible = false;
		if(FlxG.mouse.pressed) {
			if(_selobj != null) {
				// マウスの位置に移動
				_selobj.x = FlxG.mouse.x;
				_selobj.y = FlxG.mouse.y;
				// 枠を表示
				_selframe.visible = true;
				_selframe.x = _selobj.x - 2;
				_selframe.y = _selobj.y - 2;
			}
		}
    }

    /**
     * 描画
     */
    public override function draw():Void {
        super.draw();
    }
}