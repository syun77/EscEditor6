package;

class Resources {
    public static inline var FONT_PATH:String = "assets/fonts/PixelMplus12-Regular.ttf";
    public static inline var FONT_SIZE:Int = 20;
    
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
}