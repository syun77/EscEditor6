package esc.loader;

import openfl.Assets;
import flixel.text.FlxText;
import dat.SceneDB;
import esc.EscFlag;

class EscLoader {
    public var bg:EscObj;
    public var objs:Array<EscObj>;
    public var movings:Array<EscObj>;
    var _sceneID:Int;
    var _root:String;

    public function new(sceneID:Int) {
        _sceneID = sceneID;
        // 基準フォルダを設定
        _root = Resources.getSceneDirectory(sceneID);
        trace('EscLoader create. "${_root}"');

        objs = new Array<EscObj>();
        movings = new Array<EscObj>();

        var scenes = dat.SceneDB.get(sceneID);
        // 背景
        for(b in scenes.bgs) {
            bg = new EscObj(_root);
            bg.type = "bg";
            bg.x = b.x;
            bg.y = b.y;
            bg.id = b.id;
            bg.image = _toPath(b.file);
        }

        // オブジェクト
        if(scenes.objs != null) {
            for(obj in scenes.objs) {
                var o = new EscObj(_root);
                o.type = "obj";
                o.id = obj.id;
                o.x  = obj.x;
                o.y  = obj.y;
                o.image   = _toPath(obj.file);
                o.click   = obj.click;
                o.flagOn  = obj.on;
                o.flagOff = obj.off;
                objs.push(o);
            }
        }

        // 移動カーソル
        if(scenes.moves != null) {
            for(move in scenes.moves) {
                var o = new EscObj(_root);
                o.type    = "move";
                o.id      = Direction.toString(move.id.toInt());
                o.clickToJump = move.jump;
                o.click   = move.click;
                o.flagOn  = move.on;
                o.flagOff = move.off;
                movings.push(o);
            }
        }
    }

    public function getRoot():String {
        return _root;
    }

    public function getScriptPath():String {
        return '${_root}${Utils.fillZero(_sceneID, 3)}.csv';
    }

    /**
     * 更新
     */
    public function update():Void {
        bg.updateText();
        for(obj in objs) {
            obj.updateText();
        }
    }

    public function build():String {
        var str:String = '<?xml version="1.0" encoding="utf-8" ?>\n';
        str += "<data>\n";
        str += "\t" + bg.buildTag() + "\n";
        for(obj in objs) {
            str += "\t" + obj.buildTag() + "\n";
        }
        for(moving in movings) {
            str += "\t" + moving.buildTag() + "\n";
        }
        str += "</data>\n";

        return str;
    }

    function _toPath(file:String):String {
        return StringTools.replace(StringTools.replace(file, "../../", ""), _root, "");
    }
}