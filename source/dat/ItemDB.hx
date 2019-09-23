package dat;

import esc.EscGlobal;

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

    /**
     * アイテム合成チェック
     * @param itemID1 アイテム1
     * @param itemID2 アイテム2
     * @return Int 合成できる場合は 0以上のアイテムID
     */
    public static function checkCraft(itemID1:Int, itemID2:Int):Int {
        for(item in EscDB.items.all) {
            var cnt:Int = 0;
            if(item.materials == null) {
                continue;
            }
            if(item.craft_flag != null) {
                if(EscGlobal.flagCheck(item.craft_flag.value) == false) {
                    // フラグが立っていないので合成できない
                    continue;
                }
            }
            for(mat in item.materials) {
                if(mat.material.value == itemID1 || mat.material.value == itemID2) {
                    cnt++;
                }
            }
            if(cnt >= 2) {
                // 合成可能
                return item.value;
            }
        }

        // 合成できない
        return EscGlobal.ITEM_INVALID;
    }

}