package esc;

class EscFlag {
	public static inline var TEST_FLAG:Int = 10;
	public static inline var GAIN_CELL_PHONE:Int = 11;
	public static inline var GAIN_DRIVER:Int = 12;
	public static inline var GAIN_BATTERY:Int = 13;
	public static inline var GAIN_KNIFE:Int = 14;
	public static inline var GAIN_STICK:Int = 15;
	public static inline var GAIN_FIRE_STICK:Int = 16;
	public static inline var GAIN_FIRE_BATTERY:Int = 17;
	public static inline var GAIN_NOTE1:Int = 18;
	public static inline var GAIN_NOTE2:Int = 19;
	public static inline var OPEN_ENTRANCE_INPUT:Int = 30;
	public static inline var UNLOCK_ENTRANCE_INPUT:Int = 31;
	public static inline var READ_ENTRANCE_INPUT:Int = 32;
	public static inline var AWARE_PLAYER:Int = 40;
	public static inline var GONE_WOLF:Int = 41;
	public static inline var FIT_BOTH:Int = 53;
	public static inline var HAND1_ON:Int = 20;
	public static inline var HAND1_OFF:Int = 21;
	public static inline var HAND2_ON:Int = 22;
	public static inline var HAND2_OFF:Int = 23;
	public static inline var LASTDOOR_HINT1:Int = 61;
	public static inline var UNLOCK_LASTDOOR:Int = 62;
	static var _tbl:Map<String, Int> = [
		"TEST_FLAG" => 10,
		"GAIN_CELL_PHONE" => 11,
		"GAIN_DRIVER" => 12,
		"GAIN_BATTERY" => 13,
		"GAIN_KNIFE" => 14,
		"GAIN_STICK" => 15,
		"GAIN_FIRE_STICK" => 16,
		"GAIN_FIRE_BATTERY" => 17,
		"GAIN_NOTE1" => 18,
		"GAIN_NOTE2" => 19,
		"OPEN_ENTRANCE_INPUT" => 30,
		"UNLOCK_ENTRANCE_INPUT" => 31,
		"READ_ENTRANCE_INPUT" => 32,
		"AWARE_PLAYER" => 40,
		"GONE_WOLF" => 41,
		"FIT_BOTH" => 53,
		"HAND1_ON" => 20,
		"HAND1_OFF" => 21,
		"HAND2_ON" => 22,
		"HAND2_OFF" => 23,
		"LASTDOOR_HINT1" => 61,
		"UNLOCK_LASTDOOR" => 62,
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
