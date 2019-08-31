package esc;

class EscFlag {
	public static inline var UNLOCK_GATE_A:Int = 10;
	public static inline var UNLOCK_GATE_B:Int = 11;
	public static inline var UNLOCK_GATE_C:Int = 12;
	public static inline var UNLOCK_GATE_D:Int = 13;
	public static inline var UNLOCK_GATE_E:Int = 14;
	public static inline var UNLOCK_GATE_F:Int = 15;
	public static inline var PULL_DRAWER:Int = 30;
	static var _tbl:Map<String, Int> = [
		"UNLOCK_GATE_A" => 10,
		"UNLOCK_GATE_B" => 11,
		"UNLOCK_GATE_C" => 12,
		"UNLOCK_GATE_D" => 13,
		"UNLOCK_GATE_E" => 14,
		"UNLOCK_GATE_F" => 15,
		"PULL_DRAWER" => 30,
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
