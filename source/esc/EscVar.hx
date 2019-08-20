package esc;

class EscVar {
	public static inline var ITEM:Int = 0;
	public static inline var RET:Int = 1;
	public static inline var UNLOCK_CNT:Int = 50;
	static var _tbl:Map<String, Int> = [
		"ITEM" => 0,
		"RET" => 1,
		"UNLOCK_CNT" => 50,
	];
	static var _tbl2:Map<Int, String> = [ // 逆引きテーブル
		0 => "ITEM",
		1 => "RET",
		50 => "UNLOCK_CNT",
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
