package;

import openfl.Assets;
import flixel.text.FlxText;

class EscObj {
    public var type:String = "";
    public var id:String   = "";
    public var x:Float     = 0;
    public var y:Float     = 0;
    public var image:String = "";
    public var click:String = "";
    public var flagOn:Int  = 0;
    public var flagOff:Int = 0;

    var _root:String;

    // デバッグ情報
    var _txt:FlxText = null;

    public function new(root:String) {
        _root = root;
    }

    public function getImage():String {
        return _root + image;
    }

    public function getClick():String {
        if(click == "") {
            return null;
        }
        return Assets.getText('${_root}${click}.txt');
    }

    public function getString():String {
        var str:String = "";
        str += '[${type},${id}] ';
        str += "(x,y)=(" + Std.int(x) + "," + Std.int(y) + ") ";
        str += '${image} ';
        str += 'click=${click} ';
        str += 'On:${flagOn} Off:${flagOff} ';

        return str;
    }
    public function buildTag():String {
        var str:String = "";
        str += "<" + type + " " + _buildAttr("id", id);
        str += _buildAttr("image", image);
        str += _buildAttrInt("x", Std.int(x));
        str += _buildAttrInt("y", Std.int(y));
        str += _buildAttr("click", click);
        str += _buildAttrInt("on", flagOn);
        str += _buildAttrInt("off", flagOff);
        str += "/>";
        return str;
    }

    function _buildAttr(key:String, val:String):String {
        return '${key}="${val}" ';
    }
    function _buildAttrInt(key:String, val:Int):String {
        return '${key}="${val}" ';
    }

    // デバッグ情報用のテキストを更新する
    public function updateText():Void {
        if(_txt != null) {
            _txt.text = getString();
        }
    }

    // デバッグ情報用のテキストを設定する
    public function setText(txt:FlxText):Void {
        _txt = txt;
    }
}

class EscLoader {
    public var bg:EscObj;
    public var objs:Array<EscObj>;
    var _root:String;

    public function new(root:String) {
        // 基準フォルダを設定
        _root = root;
        trace('EscLoader create. "${root}"');

        objs = new Array<EscObj>();

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
        obj.image = xml.get("image");
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
        str += "</data>\n";

        return str;
    }
}