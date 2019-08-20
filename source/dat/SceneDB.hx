package dat;

class SceneDB {
    public static function get(sceneID:Int):Layout.Scenes {
        for(scene in Layout.scenes.all) {
            if(sceneID == scene.scene) {
                return scene;
            }
        }

        return null;
    }
}

