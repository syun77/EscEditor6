package;

import flixel.FlxG;
import flixel.FlxSprite;

class Utils {
	/**
     * ０埋めした数値文字列を返す
     * @param	n 元の数値
     * @param	digit ゼロ埋めする桁数
     * @return  ゼロ埋めした文字列
     */
	public static function fillZero(n:Int, digit:Int):String {
		var str:String = "" + n;
		return StringTools.lpad(str, "0", digit);
	}

     public static function checkClickSprite(spr:FlxSprite):Bool {
          if(spr.visible == false) {
               // 非表示時はクリックできない
               return false;
          }

          var x:Float = FlxG.mouse.x;
          var y:Float = FlxG.mouse.y;
          
          var x1:Float = spr.x;
          var y1:Float = spr.y;
          var x2:Float = spr.x + spr.width;
          var y2:Float = spr.y + spr.height;
          if(x1 < x && x < x2) {
               if(y1 < y && y < y2) {
                    // 画像領域内にマウスカーソルが存在する
                    return true;
               }
          }

          return false;
     }

     public static function lerpRatio(v:Float, min:Float, max:Float, ease:Float->Float=null):Float {
          if(v <= min) {
               return 0;
          }
          if(v >= max) {
               return 1;
          }
          if(min == max) {
               return 1;
          }
          
          if(ease == null) {
               ease = function(t) return t;
          }

          return ease((v - min) / (max-min));
     }
}