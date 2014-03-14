/**
 * Created by falk@aboutflash.de on 13.03.14.
 */
package mw.shipsgame.main {
import flash.geom.Point;
import flash.geom.Rectangle;

import mw.shipsgame.sprites.ship.*;

import starling.animation.IAnimatable;
import starling.core.Starling;

public class CollisionDetector implements IAnimatable {
    private var ship:Ship;

    public function CollisionDetector(ship:Ship) {
        this.ship = ship;
    }


    public function advanceTime(time:Number):void {
        detectStageBorderCollision();
    }

    private function detectStageBorderCollision():void {
        if (isOutsideStage()) {
            ship.stop();
        }
    }

    private function isOutsideStage():Boolean {
        var stageRect:Rectangle = new Rectangle(0, 0, Starling.current.stage.stageWidth, Starling.current.stage.stageHeight);
        var shipPosition:Point = new Point(ship.x, ship.y);
        return stageRect.containsPoint(shipPosition) == false;
    }


}
}
