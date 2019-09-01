package ui;

import flixel.group.FlxSpriteGroup;
import flixel.util.FlxDestroyUtil;
import ui.SceneNameUI;
import ui.SavingUI;
import ui.ScoreUI;

/**
 * テロップ表示管理
 */
class TelopUI extends FlxSpriteGroup {
    
    /**
     * コンストラクタ
     */
    public function new() {
        super();

        // スコア表示は常駐
        this.add(new ScoreUI());
    }

    /**
     * シーン名表示開始
     */
    public function startSceneName(sceneID:Int):Void {
        this.add(new SceneNameUI(sceneID));
    }

    /**
     * セーブ中表示開始
     */
    public function startSaving():Void {
        this.add(new SavingUI());
    }

    /**
     * 更新
     * @param elapsed 
     */
    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        for(obj in members) {
            if(obj.exists == false) {
                // 存在しなくなったら消す
                this.remove(obj, true);
                FlxDestroyUtil.destroy(obj);
            }
        }
    }
}