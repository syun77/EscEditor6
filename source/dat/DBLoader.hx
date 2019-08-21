package dat;

/**
 * CastleDBを読み込む
 */
class DBLoader {
    public static function load():Void {
        // CDBファイル読み込み
        var content = openfl.Assets.getText("source/dat/esc.cdb");
        // ロード実行
        EscDB.load(content);
    }
}