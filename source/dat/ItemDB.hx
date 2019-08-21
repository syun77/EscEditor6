package dat;

/**
 * アイテム情報
 */
class ItemDB {
    public static function get(itemID:Int):Layout.Items {
        for(item in Layout.items.all) {
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