package esc;

import ui.SelectUI;
import ui.SelectUI.SelectParam;
import flixel.FlxSubState;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.util.FlxDestroyUtil;
import esc.loader.EscLoader;
import esc.loader.EscObj;
import ui.InformationUI;
import ui.MovingCursorUI;
import ui.TapUI;
import ui.ItemMenuUI;
import ui.DebugMenuSubState;
import ui.ItemButtonUI;
import ui.MenuUIBase;
import ui.NumberInputUI;
import ui.PictureInputUI;
import ui.DragPanelInputUI;
import ui.KanaInputUI;
import ui.TelopUI;
import state.TitleState;
import save.GameData;

// 次に進むState
typedef NEXT_STATE = TitleState;

/**
 * 状態
 */
private enum State {
    Init;       // 初期化
    FadeInWait; // フェードイン待ち
    Execute;    // 実行中
    ScriptWait; // スクリプト終了待ち
    MenuUIWait; // 何かUIを開いている
    NextScene;  // 次のシーンに進む
    Completed;  // ゲームクリア
    TimeUp;     // 時間ぎれ
}

class EscEditor extends FlxSubState {

    public static inline var FADE_TIME:Float = 0.25;

    var _isEdit:Bool = false;
    var _state:State = State.Init;
    var _loader:EscLoader;
    var _bg:EscSprite;
    var _objs:Array<EscSprite>;
    var _bgBlank:FlxSprite;

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
    var _activeUI:MenuUIBase; // 実行中のオーバーレイするメニューUI
    var _activeUILayer:FlxSpriteGroup;
    

    // スクリプト
    var _script:EscScript;

    var _txtCompleted:FlxText;
    var _telop:TelopUI;

    // デバッグ
    var _txtDebug:FlxText;

    /**
     * コンストラクタ
     */
    public function new(sceneID:Int, isEdit:Bool) {
        super();

        _isEdit = isEdit;
        _loader = new EscLoader(sceneID);
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

        // 隠す背景
        {
            _bgBlank = new FlxSprite(0, Const.getBottom()).makeGraphic(FlxG.width, Const.MARGIN_HEIGHT, FlxColor.BLACK);
            this.add(_bgBlank);
        }

        // ヘルプテキスト
        for(txt in _txts) {
            this.add(txt);
        }


        // 表示オブジェクト更新
        _updateObjVisible();

        _activeUI = null;

        // アイテムボタン
        _btnItem = new ItemButtonUI();
        this.add(_btnItem);

        // 移動カーソル
        _movingCursorUI = new MovingCursorUI(_loader.movings);
        this.add(_movingCursorUI);
        
        // 通知テキスト
        _informationUI = new InformationUI();
        this.add(_informationUI);

        // アクティブUIレイヤー
        _activeUILayer = new FlxSpriteGroup();
        this.add(_activeUILayer);

        // スクリプト生成
        _script = new EscScript();

        // タップエフェクト
        _tapUI = new TapUI();
        this.add(_tapUI);

        // テロップ
        _telop = new TelopUI();
        this.add(_telop);

        // 現在のシーン名表示
        _telop.startSceneName(sceneID);

        // ゲームクリア
        _txtCompleted = new FlxText(0, Const.getCenterY(), FlxG.width, "", 32);
        _txtCompleted.y -= _txtCompleted.height/2;
        _txtCompleted.alignment = FlxTextAlign.CENTER;
        _txtCompleted.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        this.add(_txtCompleted);

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

    public function openNumberInput():Void {
        var menu = new NumberInputUI();
        menu.open();
        _openMenu(menu, true);
    }

    public function openPictureInput(pictureID:Int, digit:Int):Void {
        var menu = new PictureInputUI();
        menu.open(pictureID, digit);
        _openMenu(menu, true);
    }

    public function openPanelInput(panelID:Int):Void {
        var menu = new DragPanelInputUI(panelID);
        menu.funcClosed = function() {
            // 結果を保存する
            if(menu.getResult()) {
                EscGlobal.retSet(1); // 成功
            }
            else {
                EscGlobal.retSet(0);
            }
            // スクリプト処理を続行する
            _state = State.ScriptWait;
        }
        _openMenu(menu, false);
    }

    public function openSelect(param:SelectParam):Void {
        var menu = new SelectUI(param);
        menu.funcClosed = function() {
            // 選択結果を保持
            EscGlobal.retSet(menu.getSelectIdx());
            // スクリプト処理を続行する
            _state = State.ScriptWait;
        }
        _openMenu(menu, false);
    }

    public function openKanaInput(kanaID:Int):Void {
        var menu = new KanaInputUI(kanaID);
        menu.funcClosed = function() {
            // 結果を保存する
            if(menu.getResult()) {
                EscGlobal.retSet(1); // 成功
            }
            else {
                EscGlobal.retSet(0);
            }
            // スクリプト処理を続行する
            _state = State.ScriptWait;
        }
        _openMenu(menu, false);
    }

    /**
     * スクリプトを開始する
     * @param path スクリプトのパス
     * @param funcName 開始する関数名
     * @return Bool 実行できたらtrue
     */
    public function startScript(path:String, funcName:String = null):Bool {

        if(funcName == null) {
            // ファイルの先頭から実行する
            _script.execute(path);
        }
        else {
            // スクリプト実行
            if(_script.execute(path, funcName) == false) {
                // 指定の関数名がない
                return false;
            }
        }

        _state = State.ScriptWait;
        return true;
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
        var tmp = new Array<EscSprite>();
        for(obj in _objs) {
            tmp.push(obj);
        }
        tmp.reverse(); // 逆順にする
		for(obj in tmp) {
            if(Utils.checkClickSprite(obj)) {
                if(isEdit() == false) {
                    // 通常モード
                    if(obj.getObj().click == "") {
                        continue; // イベントがない場合は判定しない
                    }
                }
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

        if(obj.clickToJump != null) {
            // シーン遷移有効
            trace('SCENE JUMP -> ${obj.clickToJump.id}');
            EscGlobal.setNextSceneID(obj.clickToJump.value);
            _state = State.ScriptWait; // スクリプト街に進めることでシーン遷移チェックができる
            return;
        }

        if(obj.click == "") {
            return; // クリックイベントが存在しない
        }

        var path = _loader.getScriptPath();
        trace('click: ${path} :${obj.click}');
        // スクリプト実行
        startScript(path, obj.click);

        // ■"click" 属性をファイル名とする場合
        //var path = '${_loader.getRoot()}${obj.click}.csv';
        //trace('click: ${path}');
        // スクリプト実行
        //_script.execute(path);
    }

    /**
     * 更新
     */
    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        switch(_state) {
            case State.Init:
                var path = _loader.getScriptPath();
                // シーン開始スクリプトがあれば実行
                if(startScript(path, "init") == false) {
                    // 存在しない場合はそのままフェード処理
                    _state = State.FadeInWait;
                }

            case State.FadeInWait:
                _state = State.Execute;
            case State.Execute:
                _updateExecute();
            case State.ScriptWait:
                _updateScriptWait(elapsed);
            case State.MenuUIWait:
                if(_activeUI.isClosed()) {
                    // アイテムメニューを閉じた
                    _state = State.Execute;
                    if(_activeUI.funcClosed != null) {
                        // コールバック関数があれば呼び出し
                        _activeUI.funcClosed();
                    }
                    _activeUILayer.remove(_activeUI);
                    _activeUI = FlxDestroyUtil.destroy(_activeUI);
                }
            case State.NextScene:
                // 次のシーンに進む
            case State.Completed:
                // ゲームクリア
                if(_txtCompleted.size > 32) {
                    _txtCompleted.size -= 2;
                }
            case State.TimeUp:
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

#if debug
        // デバッグテキスト更新
        _txtDebug.text = '${_state}';
        _updateDebugInput();
#end

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

    function _updateScriptWait(elapsed:Float):Void {
        _script.update(elapsed);
        if(_script.isEnd()) {
            trace('script.isEnd() -> sceneID = ${EscGlobal.getNextSceneID()}');
            if(EscGlobal.hasNextSceneID()) {
                // 次のシーンに進む
                _state = State.NextScene;
                // フェード開始
                FlxG.camera.fade(FlxColor.BLACK, FADE_TIME, false, function() {
                    // フェード完了で閉じる
                    close();
                }, true);
            }
            else if(_script.isCompleted()) {
                _state = State.Completed;
                _txtCompleted.text = "COMPLETED";
                _txtCompleted.size = 80;
                new FlxTimer().start(3, function(_) {
                    FlxG.switchState(new NEXT_STATE());
                });
            }
            else if(_activeUI != null) {
                _state = State.MenuUIWait;
            }
            else {
                _movingCursorUI.update(elapsed);
                _state = State.Execute;
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
            case State.MenuUIWait:
                ui.visible = false;
            case State.NextScene:
                ui.visible = false;
            case State.Completed:
                ui.visible = false;
            case State.TimeUp:
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
     * メニューを開く
     */
    function _openMenu(ui:MenuUIBase, onEndToScript):Void {
        if(onEndToScript) {
            ui.funcClosed = function() {
                // 実行後はスクリプト再生に戻す
                _state = State.ScriptWait;
            }
        }
        _activeUI = ui;
        _activeUILayer.add(ui);
        _state = State.MenuUIWait;
    }
    function _openItemMenu():Void {
        var menu = new ItemMenuUI(_btnItem);
        menu.open();
        _openMenu(menu, false);
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
		if(FlxG.keys.justPressed.SPACE) {
			// デバッグメニュー起動
			openSubState(new DebugMenuSubState(FlxColor.fromRGB(0, 0, 0, 0x80)));
		}
        if(FlxG.keys.justPressed.S) {
            // セーブ
            _telop.startSaving();
            GameData.save();
        }
        if(FlxG.keys.justPressed.L) {
            // ロード
            // 次のシーンに進む
            _state = State.NextScene;
            // フェード開始
            FlxG.camera.fade(FlxColor.BLACK, FADE_TIME, false, function() {
                if(GameData.load()) {
                    // フェード完了で閉じる
                    EscGlobal.setNextSceneID(EscGlobal.getNowSceneID());
                    trace("EscEditor.update() -> close()");
                    close();
                }
                else {
                    // セーブデータがないので、フェード解除
                    EscGlobal.setNextSceneID(EscGlobal.getNowSceneID());
                    FlxG.camera.fade(FlxColor.BLACK, FADE_TIME);
                }
            }, true);
        }
    }
}
