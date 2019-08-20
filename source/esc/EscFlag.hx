package esc;

class EscFlag {
	public static inline var OPEN_DOOR:Int = 50;
	static var _tbl:Map<String, Int> = [
		"OPEN_DOOR" => 50,
	];
	static var _tbl2:Map<Int, String> = [ // 逆引きテーブル
		50 => "OPEN_DOOR",
	];
	public static function get(k:String):Int {
		if(_tbl.exists(k)) {
			return _tbl[k];
		}
		return 0;
	}
	public static function toString(v:Int):String {
		if(_tbl2.exists(v)) {
			return _tbl2[v];
		}
		return "";
	}
}
