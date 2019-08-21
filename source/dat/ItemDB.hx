package dat;

/**
 * アイテム情報
 */
class ItemDB {
    public static function get(itemID:Int):EscDB.Items {
        for(item in EscDB.items.all) {
            if(itemID == item.id) {
                return item;
            }
        }

        // 見つからなかった
        return null;
    }

    public static function name(itemID:Int):String {
        var item = get(itemID);
        return item.name;
    }

}