package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;
import esc.EscEditor;
import esc.EscGlobal;
import ui.InformationUI;

/**
 * 状態
 */
private enum State {
	SelectScene; // シーン撰択
	EditScene;   // シーン編集
	NextScene;   // 次のシーンに進む
}

class PlayState extends FlxState {

	static inline var FADE_TIME:Float = 0.25;

	// 状態
	var _state:State = State.SelectScene;

	var _isEdit:Bool = false;
	var _cursor:Int = 1;
	var _cursorSpr:FlxSprite;
	var _txts:Array<FlxText>;
	var _txtEdit:FlxText;

	// シーン編集
	var _editor:EscEditor;

	/**
	 * Editorを取得する
	 */
	public static function getEditor():EscEditor {
		if(Std.is(FlxG.state, PlayState)) {
			var playstate = cast(FlxG.state, PlayState);
			return playstate._getEditor();
		}
		return null;
	}
	/**
	 * アイテムUIを取得する
	 */
	public static function getInformationUI():InformationUI {
		if(Std.is(FlxG.state, PlayState)) {
			var playstate = cast(FlxG.state, PlayState);
			return playstate._getInformationUI();
		}
		return null;
	}

	/**
	 * 生成
	 */
	override public function create():Void {
		super.create();

		// グローバル変数初期化
		EscGlobal.init();

		// カーソルを生成
		_cursorSpr = new FlxSprite(0, 0).makeGraphic(120, 20, FlxColor.GREEN);
		this.add(_cursorSpr);

		// メニューテキスト
		_txts = new Array<FlxText>();
		var x = 32;
		var y = 48;
		for(i in 1...32) {
			var path = Resources.getScenePath(i, false);
			if(Assets.exists(path) == false) {
				break; // シーンデータが存在しない
			}
			var txt = new FlxText(x, y, 0, "Scene" + Utils.fillZero(i, 3), 20);
			_txts.push(txt);
			y += 24;
		}
		for(txt in _txts) {
			this.add(txt);
		}

		_txtEdit = new FlxText(300, 32, 0, "", 12);
		this.add(_txtEdit);

#if !debug
		// デバッグでなければ直接開始
		_cursorSpr.visible = false;
		// 指定のシーンを実行する
		_openEditor(_cursor);
		_state = State.EditScene;
#end
	}

	/**
	 * 更新
	 */
	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		switch(_state) {
			case State.SelectScene:
				_updateSelectScene();
			case State.EditScene:
				_updateEditScene();
			case State.NextScene:
				// 次のシーンへ進む
		}
	}

	function _updateSelectScene():Void {

		_setVisibleAll(true);

		var max = _txts.length;
		if(FlxG.keys.justPressed.UP) {
			_cursor--;
			if(_cursor < 1) {
				_cursor = max;
			}
		}
		if(FlxG.keys.justPressed.DOWN) {
			_cursor++;
			if(_cursor > max) {
				_cursor = 1;
			}
		}
		if(FlxG.keys.justPressed.E) {
			_isEdit = (_isEdit == false);
		}
		if(_isEdit) {
			_txtEdit.text = "Edit: On";
		}
		else {
			_txtEdit.text = "Edit: Off";
		}
		_cursorSpr.x = _txts[_cursor - 1].x;
		_cursorSpr.y = _txts[_cursor - 1].y;
		_cursorSpr.visible = true;
		if(FlxG.keys.justPressed.Z) {
			_cursorSpr.visible = false;
			// 指定のシーンを実行する
			_openEditor(_cursor);
			_state = State.EditScene;
		}
	}

	function _updateEditScene():Void {

		_setVisibleAll(false);

		if(EscGlobal.hasNextSceneID()) {
			// 次のシーンに進む
			trace('_updateEditScene() -> hasNextSceneID: ${EscGlobal.getNextSceneID()}');
			// 次に進むシーンを取得する
			var next = EscGlobal.getNextSceneID();
			EscGlobal.clearNextSceneID();
			_isEdit = EscGlobal.isEdit();
			// 次のシーンに遷移する
			_openEditor(next);

			FlxG.camera.fade(FlxColor.BLACK, FADE_TIME, true);
		}
	}

	/**
	 * EscEditorを開く
	 */
	function _openEditor(sceneID:Int):Void {
		_editor = new EscEditor(sceneID, _isEdit);
		_editor.closeCallback = function() {
			if(EscGlobal.hasNextSceneID() == false) {
				// 次のシーンがなければシーン選択に戻る
				_state = State.SelectScene;
			}
		};
		openSubState(_editor);
	}

	function _getEditor():EscEditor {
		return _editor;
	}
	function _getInformationUI():InformationUI {
		return _editor.getInformationUI();
	}

	function _setVisibleAll(b:Bool):Void {
		_txtEdit.visible = b;
		_cursorSpr.visible = b;
		for(txt in _txts) {
			txt.visible = b;
		}
	}
}
