/**
 * Created by falk@aboutflash.de on 14.03.14.
 */
package mw.shipsgame.main.constants {
public class Gameplay {
    public static const SHIP_MAX_FORWARD_SPEED_STEPS:Number = 50;
    public static const SHIP_MAX_BACKWARD_SPEED_STEPS:Number = 20;
    public static const SHIP_SPEED_FACTOR:Number = 6; // this defines the actual speed of the ship per speed step
    public static const SHIP_ROTATION_STEP_DEGREES:Number = 2;
    public static const SHIP_DEFAULT_HEALTH_POINTS:int = 100;

    public static const PROJECTILE_DEFAULT_DAMAGE_POINTS:Number = 1;
    public static const PROJECTILE_DEFAULT_SPEED:Number = 500;
    public static const PROJECTILE_DEFAULT_TTL_SECONDS:Number = 1;
}
}
