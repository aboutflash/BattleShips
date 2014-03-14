/**
 * Created by falk@aboutflash.de on 13.03.14.
 */
package mw.shipsgame.utils {
public class Mathutil {
    public static const PI_BY_HALFCIRCLE:Number = Math.PI / 180;
    public static const HALFCIRCLE_BY_PI:Number = 180 / Math.PI;

    public static function degreesToRadians(degrees:Number):Number {
        return degrees * PI_BY_HALFCIRCLE;
    }

    public static function radiansToDegrees(radians:Number):Number {
        return radians * HALFCIRCLE_BY_PI;
    }
}
}
