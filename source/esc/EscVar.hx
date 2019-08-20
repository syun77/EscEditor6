package esc;

class EscVar {
	// ■変数
	public static inline var ITEM:Int = 0;
	public static inline var RET:Int = 1;
	public static inline var UNLOCK_CNT:Int = 50;
	var _tbl:Map<String, Int> = [
		"ITEM" => 0,
		"RET" => 1,
		"UNLOCK_CNT" => 50,
	];
	public function get(k:String):Int {
		if(_tbl.exists(k)) {
			return _tbl[k];
		}
		return 0;
	}
}
