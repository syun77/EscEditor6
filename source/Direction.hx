package;

enum Dir {
    Left;
    Up;
    Right;
    Down;
}

class Direction {
    public static inline var LEFT:Int  = 0;
    public static inline var UP:Int    = 1;
    public static inline var RIGHT:Int = 2;
    public static inline var DOWN:Int  = 3;
    public static inline var MAX:Int   = 4;

    public static function toString(dir:Int):String {
        switch(dir) {
            case LEFT:  return "left";
            case UP:    return "up";
            case RIGHT: return "right";
            case DOWN:  return "down";
            default:    return "none";
        }
    }
}
