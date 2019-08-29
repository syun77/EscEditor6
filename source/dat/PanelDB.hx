package dat;

/**
 * パネルを使ったパズル管理
 */
class PanelDB {
    public static function get(id:Int):EscDB.Panels {
        for(panel in EscDB.panels.all) {
            if(id == panel.id) {
                return panel;
            }
        }

        // 見つからなかった
        return null;
    }
}