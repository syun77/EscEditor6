package esc;

class EscFlag {
	public static inline var TEST_FLAG:Int = 10;
	public static inline var GAIN_STICK:Int = 11;
	public static inline var GAIN_HANDLE:Int = 12;
	public static inline var GAIN_SCREWDRIVER:Int = 13;
	public static inline var TOILET_OPEN:Int = 30;
	public static inline var SEARCH_HANDLE:Int = 31;
	public static inline var FAUSET_ENABLE:Int = 40;
	public static inline var FILL_WATER:Int = 41;
	public static inline var PICK_SHEETS:Int = 50;
	public static inline var OPEN_DRAWER1:Int = 60;
	public static inline var OPEN_DRAWER2:Int = 61;
	public static inline var RELEASED_DRAWER1:Int = 62;
	static var _tbl:Map<String, Int> = [
		"TEST_FLAG" => 10,
		"GAIN_STICK" => 11,
		"GAIN_HANDLE" => 12,
		"GAIN_SCREWDRIVER" => 13,
		"TOILET_OPEN" => 30,
		"SEARCH_HANDLE" => 31,
		"FAUSET_ENABLE" => 40,
		"FILL_WATER" => 41,
		"PICK_SHEETS" => 50,
		"OPEN_DRAWER1" => 60,
		"OPEN_DRAWER2" => 61,
		"RELEASED_DRAWER1" => 62,
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
