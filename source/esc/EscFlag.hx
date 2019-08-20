package esc;

class EscFlag {
	// ■フラグ
	public static inline var OPEN_DOOR:Int = 50;
	var _tbl:Map<String, Int> = [
		"OPEN_DOOR" => 50,
	];
	public function get(k:String):Int {
		if(_tbl.exists(k)) {
			return _tbl[k];
		}
		return 0;
	}
}
