/**
 * Created by falk@aboutflash.de on 13.03.14.
 */
package mw.shipsgame.sprites.ship {
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import mw.shipsgame.main.KeyMap;

import starling.core.Starling;
import starling.events.EventDispatcher;
import starling.events.KeyboardEvent;

public class ShipController extends EventDispatcher {
    private var timer:Timer;
    private var ship:Ship;
    private var keymap:KeyMap;

    public var pressed_accelerate:Boolean;
    public var pressed_decelerate:Boolean;
    public var pressed_turnLeft:Boolean;
    public var pressed_turnRight:Boolean;
    public var pressed_fire:Boolean;


    public function ShipController(ship:Ship, keymap:KeyMap) {
        this.ship = ship;
        this.keymap = keymap;
        Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
        Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKey);

        this.timer = new Timer(50);
        timer.addEventListener(TimerEvent.TIMER, onTimer);
        timer.start();

    }

    public function destroy():void {
        Starling.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
        Starling.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKey);
        timer.stop();
        timer.removeEventListener(TimerEvent.TIMER, onTimer);
    }

    private function onTimer(event:TimerEvent):void {
        pollKeyboard();
    }

    private function onKey(event:KeyboardEvent):void {
        if (event.type == KeyboardEvent.KEY_DOWN) {
            if (event.keyCode == keymap.accelerate)
                pressed_accelerate = true;
            if (event.keyCode == keymap.decelerate)
                pressed_decelerate = true;
            if (event.keyCode == keymap.turnLeft)
                pressed_turnLeft = true;
            if (event.keyCode == keymap.turnRight)
                pressed_turnRight = true;
            if (event.keyCode == keymap.fire)
                pressed_fire = true;
        }
        if (event.type == KeyboardEvent.KEY_UP) {
            if (event.keyCode == keymap.accelerate)
                pressed_accelerate = false;
            if (event.keyCode == keymap.decelerate)
                pressed_decelerate = false;
            if (event.keyCode == keymap.turnLeft)
                pressed_turnLeft = false;
            if (event.keyCode == keymap.turnRight)
                pressed_turnRight = false;
            if (event.keyCode == keymap.fire)
                pressed_fire = false;
        }
    }

    private function pollKeyboard():void {
        if (pressed_accelerate)
            ship.accelerate();
        if (pressed_decelerate)
            ship.decelerate();
        if (pressed_turnLeft)
            ship.turnLeft();
        if (pressed_turnRight)
            ship.turnRight();
        if (pressed_fire)
            fire();
    }

    private function fire():void {
        dispatchEvent(new ShipEvent(ShipEvent.FIRE, true, {
            vector: ship.getMotionVector().clone(),
            position: getShipPosition(),
            playerName: ship.getPlayer()
        }));
    }

    private function getShipPosition():Point {
        return new Point(ship.x, ship.y);
    }
}
}
