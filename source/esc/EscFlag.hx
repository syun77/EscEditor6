package esc;

class EscFlag {
	public static inline var MOVABLE:Int = 3;
	public static inline var GAIN_USB_ADAPTER:Int = 12;
	public static inline var GAIN_USB_CABLE:Int = 13;
	public static inline var USB_POWER_ON:Int = 15;
	public static inline var UNLOCK_DOOR:Int = 16;
	public static inline var DRAWER_PULL:Int = 20;
	public static inline var GAIN_FLASHLIGHT_NA:Int = 21;
	public static inline var GAIN_FLOPPY_DISK:Int = 22;
	public static inline var GAIN_REMOTE:Int = 30;
	static var _tbl:Map<String, Int> = [
		"MOVABLE" => 3,
		"GAIN_USB_ADAPTER" => 12,
		"GAIN_USB_CABLE" => 13,
		"USB_POWER_ON" => 15,
		"UNLOCK_DOOR" => 16,
		"DRAWER_PULL" => 20,
		"GAIN_FLASHLIGHT_NA" => 21,
		"GAIN_FLOPPY_DISK" => 22,
		"GAIN_REMOTE" => 30,
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
