package;

class Resources {
	// フォント
    public static inline var FONT_PATH:String = "assets/fonts/PixelMplus12-Regular.ttf";
    public static inline var FONT_SIZE:Int = 20;

	// カーソル
	public static inline var CURSOR_PATH:String = "assets/images/common/arrow.png";
	public static inline var TAP_PATH:String    = "assets/images/common/tap.png";
	public static inline var NUM_ARROW:String   = "assets/images/common/num_arrow.png";
	public static inline var INPUT_SPR_SIZE:Float = 64;

	// ボタン
	public static inline var BTN_OK_PATH:String = "assets/images/common/ok.png";
    
	/**
	 * シーンファイルのパスを取得する
     * @param scene シーン番号 (1始まり)
     * @param isRoot ルートフォルダを取得するかどうか
     * @return シーンファイルへのパス
	 */
    public static function getScenePath(scene:Int, isRoot:Bool):String {
		if(isRoot) {
			return "assets/data/scene" + Utils.fillZero(scene, 3) + "/";
		}
		else {
			return "assets/data/scene" + Utils.fillZero(scene, 3) + "/layout.xml";
		}
    }

	/**
	 * 画像入力のパスを取得する
	 * @param inputNo 画像番号 (1始まり)
	 * @return 画像入力ファイルのパス
	 */
	public static function getInputPicturePath(inputNo:Int):String {
		return "assets/images/inputs/" + Utils.fillZero(inputNo, 3) + "/pictures.png";
	}
}