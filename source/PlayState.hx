package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import EscLoader;

class PlayState extends FlxState {

	var _editor:EscEditor;

	override public function create():Void {
		super.create();

		_editor = new EscEditor("assets/data/scene001/", true);
		this.add(_editor);

	}

	/**
	 * 更新
	 */
	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if(FlxG.keys.justPressed.R) {
			// リセット
			FlxG.resetGame();
		}
	}
}
