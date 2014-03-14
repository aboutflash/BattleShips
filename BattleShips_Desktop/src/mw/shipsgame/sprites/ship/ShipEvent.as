/**
 * Created by falk@aboutflash.de on 13.03.14.
 */
package mw.shipsgame.sprites.ship {
import starling.events.Event;

public class ShipEvent extends Event {
    public static const FIRE:String = "fire";

    public function ShipEvent(type:String, bubbles:Boolean = false, data:Object = null) {
        super(type, bubbles, data);
    }
}
}
