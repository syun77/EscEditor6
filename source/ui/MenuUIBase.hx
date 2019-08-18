package ui;

import flixel.group.FlxSpriteGroup;

class MenuUIBase extends FlxSpriteGroup {
    public var funcClosed:Void -> Void = null;

    public function isClosed():Bool {
        return exists == false;
    }
}