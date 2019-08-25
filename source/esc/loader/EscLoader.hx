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
        for(b in scenes.bgs) {
            bg = new EscObj(_root);
            bg.type = "bg";
            bg.id = b.id;
            bg.image = _toPath(b.file);
        }
        for(obj in scenes.objs) {
            var o = new EscObj(_root);
            o.type = "obj";
            o.id = obj.id;
            o.x  = obj.x;
            o.y  = obj.y;
            o.image   = _toPath(obj.file);
            o.click   = obj.click;
            o.flagOn  = _toFlag(obj.on);
            o.flagOff = _toFlag(obj.off);
            objs.push(o);
        }
        if(scenes.moves != null) {
            for(move in scenes.moves) {
                var o = new EscObj(_root);
                o.type    = "move";
                o.id      = move.id;
                o.click   = move.click;
                o.flagOn  = _toFlag(move.on);
                o.flagOff = _toFlag(move.off);
                movings.push(o);
            }
        }
/*
        // レイアウトファイル読み込み
        var file:String = _root + "layout.xml";
        var xml:String = Assets.getText(file);
        var map:Xml = Xml.parse(xml).firstElement();
        for(child in map.elements()) {
            switch(child.nodeName) {
                case "bg":
                    // 背景ノード
                    bg = _parseObj(child);
                    bg.type = "bg";
                case "obj":
                    // 配置オブジェクト
                    var obj:EscObj = _parseObj(child);
                    obj.type = "obj";
                    objs.push(obj);
                case "move":
                    // 移動オブジェクト
                    var moving = _parseObj(child);
                    moving.type = "move";
                    movings.push(moving);
            }
        }
*/
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

    function _parseObj(xml:Xml):EscObj {
        var obj:EscObj = new EscObj(_root);
        obj.id = xml.get("id");
        if(xml.exists("x")) {
            obj.x = Std.parseFloat(xml.get("x"));
        }
        if(xml.exists("y")) {
            obj.y = Std.parseFloat(xml.get("y"));
        }
        if(xml.exists("image")) {
            obj.image = xml.get("image");
        }
        if(xml.exists("click")) {
            obj.click = xml.get("click");
        }
        if(xml.exists("on")) {
            obj.flagOn = Std.parseInt(xml.get("on"));
        }
        if(xml.exists("off")) {
            obj.flagOff = Std.parseInt(xml.get("off"));
        }

        return obj;
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
    function _toFlag(flag:String):Int {
        var r = ~/\d+/;
        if(flag == "") {
            // 空文字はフラグ無効
            return 0;
        }
        if(r.match(flag)) {
            // 数値のみなら数値に変換
            return Std.parseInt(flag);
        }
        if(EscFlag.has(flag)) {
            // フラグに存在している場合は変換する
            return EscFlag.get(flag);
        }

        // それ以外はエラー
        trace('Can\'t find flag = ${flag}');
        return 0;
    }
}