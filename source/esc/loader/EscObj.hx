package esc.loader;

import flixel.text.FlxText;
import openfl.Assets;

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
        str += "(" + Std.int(x) + "," + Std.int(y) + ") ";
        str += '${image} ';
        str += '<${click}> ';
        if(flagOn > 0) {
            var s = EscFlag.toString(flagOn);
            if(s != "") {
                str += 'On:${s} ';
            }
            else {
                str += 'On:${flagOn} ';
            }
        }
        if(flagOff > 0) {
            var s = EscFlag.toString(flagOff);
            if(s != "") {
                str += 'Off:${s} ';
            }
            else {
                str += 'Off:${flagOff} ';
            }
        }

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
    public function checkVisible():Bool {
        var on = flagOn;
        var off = flagOff;
        var visible = false;
        if(on == 0 || EscGlobal.flagCheck(on)) {
            // 表示フラグが有効
            visible = true;
            if(off > 0 && EscGlobal.flagCheck(off)) {
                // 非表示フラグが有効
                visible = false;
            }
        }

        return visible;
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