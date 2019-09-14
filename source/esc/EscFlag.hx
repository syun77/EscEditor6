package esc;

class EscFlag {
	public static inline var TEST_FLAG:Int = 10;
	public static inline var GAIN_STRAP_CIRCLE:Int = 11;
	public static inline var GAIN_STRAP_TRIANGLE:Int = 12;
	public static inline var GAIN_KNIFE:Int = 13;
	public static inline var UNLOCK_PINK:Int = 40;
	static var _tbl:Map<String, Int> = [
		"TEST_FLAG" => 10,
		"GAIN_STRAP_CIRCLE" => 11,
		"GAIN_STRAP_TRIANGLE" => 12,
		"GAIN_KNIFE" => 13,
		"UNLOCK_PINK" => 40,
	];
	
	public static function get(k:String):Int {
		if(_tbl.exists(k)) {
			return _tbl[k];
		}
		return 0;
	}
	public static function has(k:String):Bool {
		return _tbl.exists(k);
	}
	// 逆引き
	public static function toString(v:Int):String {
		for(k in _tbl.keys()) {
			if(_tbl[k] == v) {
				return k;
			}
		}
		return "";
	}
	
}
