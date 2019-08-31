package esc;

class EscFlag {
	public static inline var UNLOCK_DOOR:Int = 16;
	public static inline var UNLOCK_GATE_A:Int = 20;
	static var _tbl:Map<String, Int> = [
		"UNLOCK_DOOR" => 16,
		"UNLOCK_GATE_A" => 20,
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
