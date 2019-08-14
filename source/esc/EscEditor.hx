package esc;

import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import esc.loader.EscLoader;
import esc.loader.EscObj;
import ui.InformationUI;
import ui.MovingCursorUI;
import ui.TapUI;
import ui.ItemMenuUI;
import ui.DebugMenuSubState;
import ui.ItemButtonUI;

/**
 * 状態
 */
private enum State {
    Init;       // 初期化
    FadeInWait; // フェードイン待ち
    Execute;    // 実行中
    ScriptWait; // スクリプト終了待ち
    ItemMenu;   // アイテムメニューを開いている
    NextScene;  // 次のシーンに進む
}

class EscEditor extends FlxSubState {
    public static inline var FADE_TIME:Float = 0.25;

    var _isEdit:Bool = false;
    var _state:State = State.Init;
    var _loader:EscLoader;
    var _bg:EscSprite;
    var _objs:Array<EscSprite>;

    // 選択オブジェクト
    var _selobj:EscSprite = null;
    var _selobjOfsX:Float = 0;
    var _selobjOfsY:Float = 0;
    var _selframe:FlxSprite = null;

    var _txts:Array<FlxText>;

    // UI
    var _informationUI:InformationUI;
    var _movingCursorUI:MovingCursorUI;
    var _tapUI:TapUI;
    var _btnItem:ItemButtonUI; // アイテムボタン
    var _itemMenu:ItemMenuUI; // アイテムメニュー

    // スクリプト
    var _script:EscScript;

    // デバッグ
    var _txtDebug:FlxText;

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
            _bg = new EscSprite(bg.x, bg.y, bg);
            bg.setText(_addText());
            this.add(_bg);
        }

        // 選択枠
        _selframe = new FlxSprite(0, 0);
        _selframe.visible = false;
        this.add(_selframe);

        // 配置オブジェクト
        _objs = new Array<EscSprite>();
        for(obj in _loader.objs) {
            var spr = new EscSprite(obj.x, obj.y, obj);
            obj.setText(_addText());
            _objs.push(spr);
        }

        for(obj in _objs) {
            this.add(obj);
        }

        // ヘルプテキスト
        for(txt in _txts) {
            this.add(txt);
        }


        // 表示オブジェクト更新
        _updateObjVisible();

        // アイテムボタン
        _btnItem = new ItemButtonUI();
        this.add(_btnItem);

        // アイテムメニュー
        _itemMenu = new ItemMenuUI(_btnItem);
        this.add(_itemMenu);

        // 移動カーソル
        _movingCursorUI = new MovingCursorUI(_loader.movings);
        this.add(_movingCursorUI);
        
        // 通知テキスト
        _informationUI = new InformationUI();
        this.add(_informationUI);

        // スクリプト生成
        _script = new EscScript();
        this.add(_script);

        // タップエフェクト
        _tapUI = new TapUI();
        this.add(_tapUI);

        _txtDebug = new FlxText(8, FlxG.height-32, 0, "");
        this.add(_txtDebug);

        setEdit(_isEdit);
    }

    /**
     * 編集フラグを設定する
     */
    public function setEdit(b:Bool):Void {
        EscGlobal.setEdit(b);
        _isEdit = b;
        for(txt in _txts) {
            txt.visible = b;
        }
    }
    public function isEdit():Bool {
        return _isEdit;
    }

    public function getInformationUI():InformationUI {
        return _informationUI;
    }

    /**
     * テキストの追加
     */
    function _addText():FlxText {
        var length:Int = _txts.length;
        var x:Float = 8;
        var y:Float = 8 + (length * 12);
        var txt = new FlxText(x, y);
        var size:Int = 10;
        txt.setFormat(null, size);
        txt.setBorderStyle(FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK, 1);
        _txts.push(txt);
        return txt;
    }

	/**
	 * クリックしたオブジェクトを取得
	 */
    function _clickObj():EscSprite {
		for(obj in _objs) {
            if(Utils.checkClickSprite(obj)) {
                return obj;
            }
		}

		return null;
    }

    function _clickMovingObj():EscObj {
        return _movingCursorUI.clickObj();
    }

    /**
     * オブジェクトをクリックした時の処理
     */
    function _onClick(obj:EscObj):Void {
        if(isEdit()) {
            return; // 編集モード中はクリックイベントは発生しない
        }

        var path = '${_loader.getRoot()}${obj.click}.csv';
        trace('click: ${path}');

        // スクリプト実行
        _script.execute(path);
        _state = State.ScriptWait;
    }

    /**
     * 更新
     */
    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        switch(_state) {
            case State.Init:
                _state = State.FadeInWait;
            case State.FadeInWait:
                _state = State.Execute;
            case State.Execute:
                _updateExecute();
            case State.ScriptWait:
                if(_script.isEnd()) {
                    trace('script.isEnd() -> sceneID = ${EscGlobal.getNextSceneID()}');
                    if(EscGlobal.hasNextSceneID()) {
                        // 次のシーンに進む
                        _state = State.NextScene;
                        // フェード開始
                        FlxG.camera.fade(FlxColor.BLACK, FADE_TIME, false, function() {
                            // フェード完了で閉じる
                            trace("EscEditor.update() -> close()");
                            close();
                        }, true);
                    }
                    else {
                        _movingCursorUI.update(elapsed);
                        _state = State.Execute;
                    }
                }
            case State.ItemMenu:
                if(_itemMenu.exists == false) {
                    // アイテムメニューを閉じた
                    _state = State.Execute;
                }
            case State.NextScene:
                // 次のシーンに進む
        }

        if(isEdit()) {
            // デバッグ用更新
            _updateDebug();
        }
        else {
            _updateObjVisible();
        }

        // 移動カーソル更新
        _updateMovingCursorUI();

        // デバッグテキスト更新
        _txtDebug.text = '${_state}';
        _updateDebugInput();

        if(FlxG.mouse.justPressed) {
            // タップエフェクト開始
            _tapUI.start(FlxG.mouse.x, FlxG.mouse.y);
        }
    }

    function _updateExecute():Void {

		if(FlxG.mouse.justPressed) {

            // クリックしたオブジェクトを取得する
			_selobj = _clickObj();
			if(_selobj != null) {
                _selobjOfsX = _selobj.x - FlxG.mouse.x;
                _selobjOfsY = _selobj.y - FlxG.mouse.y;
				var width:Float = _selobj.width + 4;
				var height:Float = _selobj.height + 4;
				_selframe.makeGraphic(Std.int(width), Std.int(height), FlxColor.RED);
                _onClick(_selobj.getObj());
                return;
			}

            // シーン移動
            var obj = _clickMovingObj();
            if(obj != null) {
                _onClick(obj);
                return;
            }

            // アイテムボタン
            if(_btnItem.clicked()) {
                _openItemMenu();
                return;
            }
		}
    }

    function _updateObjVisible():Void {
        for(spr in _objs) {
            spr.visible = spr.getObj().checkVisible();
        }
    }

    function _updateMovingCursorUI():Void {
        var ui = _movingCursorUI;
        switch(_state) {
            case State.Init:
                ui.visible = false;
            case State.FadeInWait:
                ui.visible = false;
            case State.Execute:
                ui.visible = true;
            case State.ScriptWait:
                ui.visible = false;
            case State.ItemMenu:
                ui.visible = false;
            case State.NextScene:
                ui.visible = false;
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
		for(i in 0..._loader.objs.length) {
			str = "";
			var obj = _loader.objs[i];
			_txts[i + 1].text = obj.getString();
		}

		_selframe.visible = false;
		if(FlxG.mouse.pressed) {
			if(_selobj != null) {
				// マウスの位置に移動
				_selobj.x = FlxG.mouse.x + _selobjOfsX;
				_selobj.y = FlxG.mouse.y + _selobjOfsY;
				// 枠を表示
				_selframe.visible = true;
				_selframe.x = _selobj.x - 2;
				_selframe.y = _selobj.y - 2;
			}
		}
    }

    /**
     * アイテムメニューを開く
     */
    function _openItemMenu():Void {
        _state = State.ItemMenu;
        _itemMenu.open();
    }

    function _updateDebugInput():Void {
		if(FlxG.keys.justPressed.E) {
			// 編集モード切り替え
			setEdit(_isEdit != true);
		}
		if(FlxG.keys.justPressed.Q) {
			// 強制終了
            close();
		}
		if(FlxG.keys.justPressed.I) {
			// アイテム撰択を開く
            if(_state == State.Execute) {
                _openItemMenu();
            }
		}
		if(FlxG.keys.justPressed.R) {
			// リセット
			FlxG.resetGame();
		}
		if(FlxG.keys.justPressed.F) {
			// フラグ編集モード切り替え
			openSubState(new DebugMenuSubState(FlxColor.fromRGB(0, 0, 0, 0x80)));
		}
    }
}
