package esc.loader;

import openfl.Assets;
import flixel.text.FlxText;



class EscLoader {
    public var bg:EscObj;
    public var objs:Array<EscObj>;
    public var movings:Array<EscObj>;
    var _root:String;

    public function new(root:String) {
        // 基準フォルダを設定
        _root = root;
        trace('EscLoader create. "${root}"');

        objs = new Array<EscObj>();
        movings = new Array<EscObj>();

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
    }

    public function getRoot():String {
        return _root;
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
}