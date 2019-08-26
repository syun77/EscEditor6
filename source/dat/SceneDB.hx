package dat;

/**
 * シーン情報管理
 */
class SceneDB {

    /**
     * シーン情報の取得
     * @param sceneID シーンID
     * @return シーン情報
     */
    public static function get(sceneID:Int):EscDB.Scenes {
        for(scene in EscDB.scenes.all) {
            if(sceneID == scene.value) {
                return scene;
            }
        }

        // 見つからなかったら null
        return null;
    }
}

