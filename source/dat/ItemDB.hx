package dat;

/**
 * アイテム情報
 */
class ItemDB {

    /**
     * アイテムデータを取得する
     * @param itemID アイテムID (value) 
     * @return EscDB.Items アイテムデータ
     */
    public static function get(itemID:Int):EscDB.Items {
        for(item in EscDB.items.all) {
            if(itemID == item.value) {
                return item;
            }
        }

        // 見つからなかった
        return null;
    }

    /**
     * アイテム名を取得する
     * @param itemID アイテムID (value) 
     * @return String アイテム名
     */
    public static function name(itemID:Int):String {
        var item = get(itemID);
        if(item == null) {
            return "";
        }
        return item.name;
    }

    /**
     * 獲得フラグの番号を取得する
     * @param itemID アイテムID (value)
     * @return Int フラグ番号
     */
    public static function flag(itemID:Int):Int {
        var item = get(itemID);
        if(item == null) {
            return 0;
        }
        return item.flag.value;
    }

}