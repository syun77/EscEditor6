package esc;

class EscVar {
	public static inline var RET:Int = 0;
	public static inline var ITEM:Int = 1;
	public static inline var CRAFT1:Int = 2;
	public static inline var CRAFT2:Int = 3;
	public static inline var UNLOCK_CNT:Int = 50;
	static var _tbl:Map<String, Int> = [
		"RET" => 0,
		"ITEM" => 1,
		"CRAFT1" => 2,
		"CRAFT2" => 3,
		"UNLOCK_CNT" => 50,
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
