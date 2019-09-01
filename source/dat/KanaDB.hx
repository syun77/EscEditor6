package dat;

/**
 * 文字入力管理
 */
class KanaDB {
    public static function get(id:Int):EscDB.Kanas {
        for(kana in EscDB.kanas.all) {
            if(id == kana.id) {
                return kana;
            }
        }

        // 見つからなかった
        return null;
    }
}
