package dat;

/**
 * フラグ情報
 */
class FlagDB {
    public static function value(id:EscDB.FlagsKind):Int {
        return EscDB.flags.get(id).value;
    }
}