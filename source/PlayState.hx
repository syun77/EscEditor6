package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Assets;

/**
 * 状態
 */
private enum State {
	SelectScene; // シーン撰択
	EditScene;   // シーン編集
}

class PlayState extends FlxState {

	// 状態
	var _state:State = State.SelectScene;

	var _cursor:Int = 1;
	var _cursorSpr:FlxSprite;
	var _txts:Array<FlxText>;

	// シーン編集
	var _editor:EscEditor;

	/**
	 * 生成
	 */
	override public function create():Void {
		super.create();

		// グローバル変数初期化
		EscGlobal.init();

		_editor = new EscEditor("assets/data/scene001/", true);

		// カーソルを生成
		_cursorSpr = new FlxSprite(0, 0).makeGraphic(120, 20, FlxColor.GREEN);
		this.add(_cursorSpr);

		// メニューテキスト
		_txts = new Array<FlxText>();
		var x = 32;
		var y = 48;
		for(i in 1...32) {
			var path = _getScenePath(i, false);
			if(Assets.exists(path) == false) {
				break; // シーンデータが存在しない
			}
			var txt = new FlxText(x, y, 0, "Scene" + fillZero(i, 3), 20);
			_txts.push(txt);
			y += 24;
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

		switch(_state) {
			case State.SelectScene:
				_updateSelectScene();
			case State.EditScene:
				_updateEditScene();
		}
		if(FlxG.keys.justPressed.R) {
			// リセット
			FlxG.resetGame();
		}
	}

	function _updateSelectScene():Void {
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
		_cursorSpr.x = _txts[_cursor - 1].x;
		_cursorSpr.y = _txts[_cursor - 1].y;
		_cursorSpr.visible = true;
		if(FlxG.keys.justPressed.Z) {
			_cursorSpr.visible = false;
			_editor = new EscEditor(_getScenePath(_cursor, true), true);
			this.add(_editor);
			_state = State.EditScene;
		}
	}

	function _updateEditScene():Void {
		if(FlxG.keys.justPressed.E) {
			var b = _editor.isEdit();
			_editor.setEdit(b != true);
		}
		if(FlxG.keys.justPressed.Q) {
			this.remove(_editor);
			_editor = null;
			_state = State.SelectScene;
		}
	}

	/**
	 * シーンファイルのパスを取得する
	 */
	function _getScenePath(scene:Int, isRoot:Bool):String {
		if(isRoot) {
			return "assets/data/scene" + fillZero(scene, 3) + "/";
		}
		else {
			return "assets/data/scene" + fillZero(scene, 3) + "/layout.xml";
		}
	}

	/**
     * ０埋めした数値文字列を返す
     * @param	n 元の数値
     * @param	digit ゼロ埋めする桁数
     * @return  ゼロ埋めした文字列
     */
	public static function fillZero(n:Int, digit:Int):String {
		var str:String = "" + n;
		return StringTools.lpad(str, "0", digit);
	}
}
