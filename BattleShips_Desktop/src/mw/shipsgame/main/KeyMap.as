/**
 * Created by falk@aboutflash.de on 13.03.14.
 */
package mw.shipsgame.main {
import flash.ui.Keyboard;

public class KeyMap {
    public static const PLAYER_1:KeyMap = new KeyMap(Keyboard.W, Keyboard.S, Keyboard.A, Keyboard.D, Keyboard.SPACE);
    public static const PLAYER_2:KeyMap = new KeyMap(Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, Keyboard.NUMPAD_0);

    public var accelerate:uint;
    public var decelerate:uint;
    public var turnLeft:uint;
    public var turnRight:uint;
    public var fire:uint;

    public function KeyMap(accelerate:uint, decelerate:uint, turnLeft:uint, turnRight:uint, fire:uint) {
        this.accelerate = accelerate;
        this.decelerate = decelerate;
        this.turnLeft = turnLeft;
        this.turnRight = turnRight;
        this.fire = fire;
    }
}
}
