package esc;

class EscFlag {
	public static inline var UNLOCK_GATE_A:Int = 10;
	public static inline var UNLOCK_GATE_B:Int = 11;
	public static inline var UNLOCK_GATE_C:Int = 12;
	public static inline var UNLOCK_GATE_D:Int = 13;
	public static inline var UNLOCK_GATE_E:Int = 14;
	public static inline var UNLOCK_GATE_F:Int = 15;
	public static inline var UNLOCK_GATE_Z:Int = 16;
	public static inline var OPEN_GATE_Z:Int = 17;
	public static inline var PULL_DRAWER:Int = 30;
	public static inline var HINT1:Int = 90;
	public static inline var HINT2:Int = 91;
	public static inline var HINT3:Int = 92;
	public static inline var HINT4:Int = 93;
	public static inline var HINT5:Int = 94;
	public static inline var HINT6:Int = 95;
	public static inline var HINT7:Int = 96;
	public static inline var HINT8:Int = 97;
	public static inline var HINT9:Int = 98;
	public static inline var STAR_A1:Int = 20;
	public static inline var STAR_A2:Int = 21;
	public static inline var STAR_B1:Int = 31;
	public static inline var STAR_B2:Int = 32;
	public static inline var STAR_B3:Int = 33;
	public static inline var STAR_B4:Int = 34;
	public static inline var STAR_B5:Int = 35;
	public static inline var STAR_C1:Int = 40;
	public static inline var STAR_C2:Int = 41;
	public static inline var STAR_D1:Int = 50;
	public static inline var STAR_D2:Int = 51;
	public static inline var STAR_E1:Int = 60;
	public static inline var STAR_E2:Int = 61;
	public static inline var STAR_F1:Int = 80;
	public static inline var STAR_Z1:Int = 99;
	public static inline var CORRECT_E:Int = 65;
	public static inline var STAR_F2:Int = 81;
	static var _tbl:Map<String, Int> = [
		"UNLOCK_GATE_A" => 10,
		"UNLOCK_GATE_B" => 11,
		"UNLOCK_GATE_C" => 12,
		"UNLOCK_GATE_D" => 13,
		"UNLOCK_GATE_E" => 14,
		"UNLOCK_GATE_F" => 15,
		"UNLOCK_GATE_Z" => 16,
		"OPEN_GATE_Z" => 17,
		"PULL_DRAWER" => 30,
		"HINT1" => 90,
		"HINT2" => 91,
		"HINT3" => 92,
		"HINT4" => 93,
		"HINT5" => 94,
		"HINT6" => 95,
		"HINT7" => 96,
		"HINT8" => 97,
		"HINT9" => 98,
		"STAR_A1" => 20,
		"STAR_A2" => 21,
		"STAR_B1" => 31,
		"STAR_B2" => 32,
		"STAR_B3" => 33,
		"STAR_B4" => 34,
		"STAR_B5" => 35,
		"STAR_C1" => 40,
		"STAR_C2" => 41,
		"STAR_D1" => 50,
		"STAR_D2" => 51,
		"STAR_E1" => 60,
		"STAR_E2" => 61,
		"STAR_F1" => 80,
		"STAR_Z1" => 99,
		"CORRECT_E" => 65,
		"STAR_F2" => 81,
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
