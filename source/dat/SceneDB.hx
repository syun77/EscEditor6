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
    public static function get(sceneID:Int):Layout.Scenes {
        for(scene in Layout.scenes.all) {
            if(sceneID == scene.scene) {
                return scene;
            }
        }

        // 見つからなかったら null
        return null;
    }
}

