package esc;

class EscFlag {
	public static inline var TEST_FLAG:Int = 10;
	public static inline var GAIN_STRAP_CIRCLE:Int = 11;
	public static inline var GAIN_STRAP_TRIANGLE:Int = 12;
	public static inline var GAIN_KNIFE:Int = 13;
	public static inline var GAIN_MEMO:Int = 14;
	public static inline var GAIN_FLOPPY:Int = 15;
	public static inline var GAIN_MASK:Int = 16;
	public static inline var OPEN_ENTRANCE_INPUT:Int = 30;
	public static inline var UNLOCK_ENTRANCE_INPUT:Int = 31;
	public static inline var READ_ENTRANCE_INPUT:Int = 32;
	public static inline var AWARE_PLAYER:Int = 40;
	public static inline var FIT_TRIANGLE:Int = 52;
	public static inline var FIT_BOTH:Int = 53;
	public static inline var HAND1_ON:Int = 20;
	public static inline var HAND1_OFF:Int = 21;
	public static inline var HAND2_ON:Int = 22;
	public static inline var HAND2_OFF:Int = 23;
	public static inline var MASK_DROP:Int = 24;
	public static inline var TRAIN3_NON_DARK:Int = 25;
	public static inline var INSERT_FLOPPY:Int = 60;
	public static inline var LASTDOOR_HINT1:Int = 61;
	public static inline var UNLOCK_LASTDOOR:Int = 62;
	static var _tbl:Map<String, Int> = [
		"TEST_FLAG" => 10,
		"GAIN_STRAP_CIRCLE" => 11,
		"GAIN_STRAP_TRIANGLE" => 12,
		"GAIN_KNIFE" => 13,
		"GAIN_MEMO" => 14,
		"GAIN_FLOPPY" => 15,
		"GAIN_MASK" => 16,
		"OPEN_ENTRANCE_INPUT" => 30,
		"UNLOCK_ENTRANCE_INPUT" => 31,
		"READ_ENTRANCE_INPUT" => 32,
		"AWARE_PLAYER" => 40,
		"FIT_TRIANGLE" => 52,
		"FIT_BOTH" => 53,
		"HAND1_ON" => 20,
		"HAND1_OFF" => 21,
		"HAND2_ON" => 22,
		"HAND2_OFF" => 23,
		"MASK_DROP" => 24,
		"TRAIN3_NON_DARK" => 25,
		"INSERT_FLOPPY" => 60,
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
